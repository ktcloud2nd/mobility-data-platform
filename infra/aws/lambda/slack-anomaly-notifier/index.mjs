/*
[Lambda 코드]
前 RDS polling Lambda
現 HTTP 요청 받는 Lambda
*/

const SLACK_WEBHOOK_URL = process.env.SLACK_WEBHOOK_URL;
const ALERT_WEBHOOK_TOKEN = process.env.ALERT_WEBHOOK_TOKEN;

function json(statusCode, body) {
  return {
    statusCode,
    headers: {
      "content-type": "application/json"
    },
    body: JSON.stringify(body)
  };
}

function getHeader(headers, name) {
  const entries = Object.entries(headers || {});
  const match = entries.find(([key]) => key.toLowerCase() === name.toLowerCase());
  return match ? match[1] : undefined;
}

function parseEventBody(event) {
  if (!event?.body) {
    return null;
  }

  const rawBody = event.isBase64Encoded
    ? Buffer.from(event.body, "base64").toString("utf8")
    : event.body;

  return JSON.parse(rawBody);
}

// 유닉스타임 KST 변환
function formatOccurredAt(timestamp) {
  if (!timestamp) return "-";

  const date = new Date(
    String(timestamp).length === 10 ? timestamp * 1000 : timestamp
  );

  return date.toLocaleString("ko-KR", {
    timeZone: "Asia/Seoul",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit"
  });
}

function formatSlackMessage(alert) {
  return {
    text: `[이상 탐지 알림] 차량 ${alert.vehicle_id}, 유형 ${alert.anomaly_type || "-"}`,
    blocks: [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: "🚨 이상 탐지 알림"
        }
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: `*차량 ID*\n${alert.vehicle_id}`
          },
          {
            type: "mrkdwn",
            text: `*유형*\n${alert.anomaly_type || "-"}`
          },
          {
            type: "mrkdwn",
            text: `*발생 시각*\n${formatOccurredAt(alert.occurred_at)}`
          },
          {
            type: "mrkdwn",
            text: `*근거*\n${alert.evidence || "-"}`
          }
        ]
      },
      {
        type: "divider"
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: `*설명*\n${alert.description || "-"}`
        }
      },
      {
        type: "actions",
        elements: [
          {
            type: "button",
            text: {
              type: "plain_text",
              text: "대시보드에서 확인하기"
            },
            url: "http://admin.palja.click"
          }
        ]
      }
    ]
  };
}

async function sendSlackMessage(payload) {
  const response = await fetch(SLACK_WEBHOOK_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`Slack send failed: ${response.status} ${text}`);
  }
}

function validateAlertPayload(alert) {
  if (!alert || typeof alert !== "object") {
    return "Alert payload is required.";
  }

  if (!alert.vehicle_id) {
    return "vehicle_id is required.";
  }

  if (!alert.anomaly_type) {
    return "anomaly_type is required.";
  }

  if (!alert.occurred_at) {
    return "occurred_at is required.";
  }

  return null;
}

export const handler = async (event) => {
  try {
    if (!SLACK_WEBHOOK_URL || !ALERT_WEBHOOK_TOKEN) {
      return json(500, {
        message: "Lambda environment is not configured."
      });
    }

    const method = event?.requestContext?.http?.method || event?.httpMethod || "POST";

    if (method !== "POST") {
      return json(405, {
        message: "Method not allowed."
      });
    }

    const providedToken =
      getHeader(event?.headers, "x-alert-token") ||
      getHeader(event?.headers, "authorization")?.replace(/^Bearer\s+/i, "");

    if (providedToken !== ALERT_WEBHOOK_TOKEN) {
      return json(401, {
        message: "Unauthorized."
      });
    }

    const alert = parseEventBody(event);
    const validationError = validateAlertPayload(alert);

    if (validationError) {
      return json(400, {
        message: validationError
      });
    }

    await sendSlackMessage(formatSlackMessage(alert));

    return json(200, {
      ok: true
    });
  } catch (error) {
    console.error("Failed to process anomaly alert event.", error);

    return json(500, {
      message: "Failed to process anomaly alert event.",
      details: error.message
    });
  }
};

function trimTrailingSlash(value = '') {
  return value.replace(/\/+$/, '');
}

function withGrafanaEmbedOptions(value = '', { theme = 'dark', kiosk = 'tv' } = {}) {
  if (!value) {
    return '';
  }

  try {
    const url = new URL(value);

    if (theme && !url.searchParams.has('theme')) {
      url.searchParams.set('theme', theme);
    }

    if (kiosk && !url.searchParams.has('kiosk')) {
      url.searchParams.set('kiosk', kiosk);
    }

    return url.toString();
  } catch {
    const params = [];

    if (theme && !value.includes('theme=')) {
      params.push(`theme=${theme}`);
    }

    if (kiosk && !value.includes('kiosk=')) {
      params.push(`kiosk=${kiosk}`);
    }

    if (!params.length) {
      return value;
    }

    const separator = value.includes('?') ? '&' : '?';
    return `${value}${separator}${params.join('&')}`;
  }
}

function normalizeGrafanaUrl(value = '', operatorHost = '', scheme = 'http') {
  if (!value) {
    return '';
  }

  if (/^https?:\/\//i.test(value)) {
    return value;
  }

  if (value.startsWith('/') && operatorHost) {
    return `${scheme}://${operatorHost}${value}`;
  }

  return value;
}

export function getGrafanaConfig() {
  const enabled = process.env.GRAFANA_ENABLED === 'true';
  const operatorHost = String(process.env.OPERATOR_APP_HOST || '').trim();
  const publicScheme = String(process.env.APP_PUBLIC_SCHEME || 'http').trim() || 'http';
  const baseUrl = trimTrailingSlash(
    normalizeGrafanaUrl(process.env.GRAFANA_BASE_URL || '', operatorHost, publicScheme)
  );
  const embedUrl = normalizeGrafanaUrl(
    process.env.GRAFANA_EMBED_URL || '',
    operatorHost,
    publicScheme
  );
  const provider = process.env.GRAFANA_PROVIDER || 'self-hosted';
  const allowEmbed = process.env.GRAFANA_ALLOW_EMBED === 'true';

  return {
    enabled,
    baseUrl,
    embedUrl: withGrafanaEmbedOptions(embedUrl, { theme: 'dark', kiosk: 'tv' }),
    provider,
    allowEmbed
  };
}

export function getGrafanaEmbedPayload() {
  const config = getGrafanaConfig();

  return {
    enabled: config.enabled && config.allowEmbed && Boolean(config.embedUrl),
    provider: config.provider,
    embedUrl: config.embedUrl
  };
}

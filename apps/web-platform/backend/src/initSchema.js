import { query } from './db.js';

const defaultModelCodes = [
  { code: 1, modelName: 'Avante', imageUrl: '/models/avante.png' },
  { code: 2, modelName: 'Grandeur', imageUrl: '/models/grandeur.png' },
  { code: 3, modelName: 'Santafe', imageUrl: '/models/santafe.png' },
  { code: 4, modelName: 'Tucson', imageUrl: '/models/tucson.png' }
];

export async function initSchema() {
  await query(`
    CREATE TABLE IF NOT EXISTS model_codes (
      code INT PRIMARY KEY,
      model_name VARCHAR(50) NOT NULL,
      image_url TEXT
    );
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS accounts (
      id SERIAL PRIMARY KEY,
      user_id VARCHAR(50) NOT NULL UNIQUE,
      password_hash VARCHAR(255) NOT NULL,
      role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'operator')),
      user_name VARCHAR(100),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS vehicle_master (
      id SERIAL PRIMARY KEY,
      vehicle_id VARCHAR(50) NOT NULL UNIQUE,
      model_code INT REFERENCES model_codes(code)
    );
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS user_vehicle_mapping (
      id SERIAL PRIMARY KEY,
      account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
      vehicle_id VARCHAR(50) NOT NULL REFERENCES vehicle_master(vehicle_id) ON DELETE CASCADE,
      UNIQUE (account_id, vehicle_id)
    );
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS vehicle_anomaly_alerts (
      id BIGSERIAL PRIMARY KEY,
      vehicle_id VARCHAR(50) NOT NULL,
      anomaly_type VARCHAR(50) NOT NULL,
      description VARCHAR(255),
      evidence VARCHAR(255),
      occurred_at BIGINT NOT NULL
    );
  `);

  await query(`
    CREATE INDEX IF NOT EXISTS idx_vehicle_anomaly_alerts_occurred_at
    ON vehicle_anomaly_alerts (occurred_at DESC);
  `);

  for (const model of defaultModelCodes) {
    await query(
      `
        INSERT INTO model_codes (code, model_name, image_url)
        VALUES ($1, $2, $3)
        ON CONFLICT (code) DO UPDATE
        SET model_name = EXCLUDED.model_name,
            image_url = EXCLUDED.image_url;
      `,
      [model.code, model.modelName, model.imageUrl]
    );
  }
}

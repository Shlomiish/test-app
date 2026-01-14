import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import { Kafka } from 'kafkajs';

const app = express();
app.use(express.json());
app.use(cors());
app.use(morgan('combined'));

const PORT = process.env.PORT || 8080;
const KAFKA_BROKER = process.env.KAFKA_BROKER || 'kafka:29092';
const KAFKA_TOPIC = process.env.KAFKA_TOPIC || 'button-events';

const kafka = new Kafka({ clientId: 'demo-server', brokers: [KAFKA_BROKER] });
const producer = kafka.producer();

async function startKafka() {
  console.log('[server] Step: connect Kafka producer...');
  await producer.connect();
  console.log('[server] Step: Kafka producer connected ✅');
}

function buildPayload(button) {
  return {
    ok: true,
    button,
    message: button === 'button1' ? 'Hello from API #1' : 'Hello from API #2',
    timestamp: new Date().toISOString(),
  };
}

async function sendKafkaEvent(payload) {
  console.log(`[server] Step: send event to Kafka topic=${KAFKA_TOPIC}`, payload);
  await producer.send({
    topic: KAFKA_TOPIC,
    messages: [{ key: payload.button, value: JSON.stringify(payload) }],
  });
  console.log('[server] Step: event sent ✅');
}

app.get('/api/button1', async (req, res) => {
  console.log('[server] Step: /api/button1 called');
  const payload = buildPayload('button1');
  await sendKafkaEvent(payload);
  res.json(payload);
});

app.get('/api/button2', async (req, res) => {
  console.log('[server] Step: /api/button2 called');
  const payload = buildPayload('button2');
  await sendKafkaEvent(payload);
  res.json(payload);
});

app.get('/api/health', (req, res) => res.json({ ok: true }));

startKafka()
  .then(() => {
    console.log('[server] Step: start HTTP server...');
    app.listen(PORT, () => console.log(`[server] listening on port ${PORT} ✅`));
  })
  .catch((err) => {
    console.error('[server] Kafka init failed ❌', err);
    process.exit(1);
  });

// graceful shutdown
process.on('SIGINT', async () => {
  console.log('[server] shutdown: disconnect producer...');
  await producer.disconnect();
  process.exit(0);
});

import { Kafka } from 'kafkajs';

const KAFKA_BROKER = process.env.KAFKA_BROKER || 'kafka:29092';
const KAFKA_TOPIC = process.env.KAFKA_TOPIC || 'button-events';
const KAFKA_GROUP_ID = process.env.KAFKA_GROUP_ID || 'demo-consumer-group';

const kafka = new Kafka({ clientId: 'demo-consumer', brokers: [KAFKA_BROKER] });
const consumer = kafka.consumer({ groupId: KAFKA_GROUP_ID });

async function run() {
  console.log('[consumer] Step: connect...');
  await consumer.connect();
  console.log('[consumer] Step: subscribe...');
  await consumer.subscribe({ topic: KAFKA_TOPIC, fromBeginning: true });
  console.log('[consumer] Step: running ✅');

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const key = message.key?.toString();
      const value = message.value?.toString();
      console.log(
        `[consumer] Step: received topic=${topic} partition=${partition} key=${key} value=${value}`
      );
    },
  });
}

run().catch((err) => {
  console.error('[consumer] failed ❌', err);
  process.exit(1);
});

process.on('SIGINT', async () => {
  console.log('[consumer] shutdown...');
  await consumer.disconnect();
  process.exit(0);
});

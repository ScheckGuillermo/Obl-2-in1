const AWS = require('aws-sdk');
const sqs = new AWS.SQS();
const s3 = new AWS.S3();

exports.handler = async (event) => {
    const queueUrl = process.env.QUEUE_URL;

    for (const record of event.Records) {
        const bucket = record.s3.bucket.name;
        const key = record.s3.object.key;

        const params = {
            Bucket: bucket,
            Key: key
        };

        try {
            const data = await s3.getObject(params).promise();
            const order = JSON.parse(data.Body.toString('utf-8'));

            console.log(`Received order: ${JSON.stringify(order)}`);

            const message = {
                id_proveedor: order.id_proveedor,
                fecha: order.fecha,
                pedido: order.pedido
            };

            const sqsParams = {
                QueueUrl: queueUrl,
                MessageBody: JSON.stringify(message)
            };

            const result = await sqs.sendMessage(sqsParams).promise();
        } catch (error) {
            console.error(`Error processing S3 object ${key} from bucket ${bucket}. Error: ${error.message}`);
        }
    }

    return {
        statusCode: 200,
        body: JSON.stringify('Order processed and message sent to SQS')
    };
};

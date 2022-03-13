import express from 'express';
import path from 'path';
import { calculateIDX, drawCenterFillSquare, drawEllipse, drawLine, drawPixel, drawQuad, drawRect } from '../Scripting/util/OtherUtil';
import { SerialPort } from 'serialport';
const app: express.Application = express();

//EJS Page
app.use('/assets', express.static('assets', {maxAge: '1d'}));
app.set('view engine', 'ejs');
app.get('/', (req: express.Request, res: express.Response) => {
    res.render(path.join(__dirname, '/App'));
});

//Serial
let serialPort: any | null = null;
function initSerialPort() {
    serialPort = new SerialPort({
        path: '\\\\.\\COM6',
        baudRate: 921600,
        parity: 'none'
    });
    serialPort.on('data', onData);
    serialPort.on('error', onError);
    serialPort.write(Buffer.from([0b00000001]));
}
initSerialPort();

//Frame
let frame: Buffer = Buffer.alloc(38400);
let framePointer: number;
function onData(newData: Buffer) {
    for (let i = 0; i < newData.length; i++) {
        frame[framePointer] = newData[i];
        framePointer++;
    }

    if (framePointer >= 38400) {
        framePointer = 0;
        serialPort.write(Buffer.from([0b00000001]));
    }
}
function onError(err: any) {
    console.error(err);
}

//Actions
app.use(express.json());
app.post('/frame', (req: express.Request, res: express.Response) => {
    try {
        res.send({ frame });
    }
    catch (e) { res.send({ error: e }); }
});

//Host Webapp
app.post('/ping', (req: express.Request, res: express.Response) => {
    res.send({ pid: process.pid });
});
const port: number = 34;
app.listen(port, () => {
  return console.log(`Serial App @ http://localhost:${port}`);
});
const cron = require('node-cron');

let times = 0;

cron.schedule('1-59/5 * * * * * *', function () {
  times++;
  console.log('Running Cron Job every 5 seconds: ', times);
});

console.log('Start Cron Job!!!');

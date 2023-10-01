let times = 0;

const syncDB = () => {
  times++;
  console.log('Running Cron Job every 5 seconds: ', times);

  return times;
};

module.exports = syncDB;

const syncDB = require('../../tasks/sync-db');

describe('sync-db', () => {
  test('should execute the process twice', () => {
    syncDB();
    const times = syncDB();

    console.log('Executed times: ', times);

    expect(times).toBe(2);
  });
});

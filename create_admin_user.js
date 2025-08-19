r.db('stf').table('users').insert({
    email: 'admindevicefarm@gmail.com',
    name: 'admin',
    privilege: 'admin',
    groups: {
      subscribed: ['*'],
      quotas: {
        allocated: { number: 999, duration: 86400000 },
        consumed: { number: 0, duration: 0 },
        defaultGroupsDuration: 86400000,
        defaultGroupsNumber: 999,
        defaultGroupsRepetitions: 0,
        repetitions: 0
      }
    },
    settings: {},
    lastLoggedInAt: r.now(),
    createdAt: r.now()
  })
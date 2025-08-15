const r = require('rethinkdb');

async function checkDatabase() {
  try {
    console.log('🔌 Connecting to RethinkDB...');
    const conn = await r.connect('rethinkdb:28015');
    console.log('✅ Connected to RethinkDB');
    
    // Check if 'stf' database exists
    const dbList = await r.dbList().run(conn);
    console.log('📚 Available databases:', dbList);
    
    if (!dbList.includes('stf')) {
      console.log('❌ Database "stf" does not exist');
      return;
    }
    
    // Check if 'users' table exists
    const tableList = await r.db('stf').tableList().run(conn);
    console.log('📋 Available tables in "stf":', tableList);
    
    if (!tableList.includes('users')) {
      console.log('❌ Table "users" does not exist');
      return;
    }
    
    // Check existing users
    const users = await r.db('stf').table('users').run(conn);
    const userArray = await users.toArray();
    console.log('👥 Existing users:', userArray.length);
    
    if (userArray.length === 0) {
      console.log('⚠️  No users found in database');
      console.log('🔧 Creating first admin user...');
      
      // Create root group first
      const rootGroup = await r.db('stf').table('groups').insert({
        name: 'Root Group',
        owner: {
          email: 'admin@stf.local',
          name: 'Administrator'
        },
        envUserGroupsNumber: 10,
        envUserGroupsDuration: 24 * 3600 * 1000, // 24 hours in milliseconds
        envUserGroupsRepetitions: 1
      }).run(conn);
      
      console.log('✅ Root group created:', rootGroup);
      
      // Create first admin user
      const adminUser = await r.db('stf').table('users').insert({
        email: 'admin@stf.local',
        name: 'Administrator',
        ip: '127.0.0.1',
        group: 'admin-group',
        lastLoggedInAt: r.now(),
        createdAt: r.now(),
        forwards: [],
        settings: {},
        privilege: 'admin',
        groups: {
          subscribed: [],
          lock: false,
          quotas: {
            allocated: {
              number: 10,
              duration: 24 * 3600 * 1000
            },
            consumed: {
              number: 0,
              duration: 0
            },
            defaultGroupsNumber: 10,
            defaultGroupsDuration: 24 * 3600 * 1000,
            defaultGroupsRepetitions: 1,
            repetitions: 1
          }
        }
      }).run(conn);
      
      console.log('✅ Admin user created:', adminUser);
      
      // Add user to root group
      const groupUpdate = await r.db('stf').table('groups').get(rootGroup.generated_keys[0]).update({
        users: r.row('users').default([]).append('admin@stf.local')
      }).run(conn);
      
      console.log('✅ User added to root group:', groupUpdate);
      
    } else {
      userArray.forEach(user => {
        console.log(`👤 User: ${user.name} (${user.email}) - Privilege: ${user.privilege}`);
      });
    }
    
    // Check groups
    const groups = await r.db('stf').table('groups').run(conn);
    const groupArray = await groups.toArray();
    console.log('🏢 Groups:', groupArray.length);
    groupArray.forEach(group => {
      console.log(`🏢 Group: ${group.name} - Owner: ${group.owner?.name || 'N/A'}`);
    });
    
    await conn.close();
    console.log('🔌 Connection closed');
    
  } catch (error) {
    console.error('❌ Error:', error);
  }
}

checkDatabase();


const sql = require('mssql');



async function queryDatabase(query) {
  try {
    const config = {
      user: "sa",
      password:  "A+1197!",
      database: "ConceptCar",
      server: "185.131.49.118",
      port: 19955,
      pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
      },
      options: {
        encrypt: false, // for azure
        trustServerCertificate: false // change to true for local dev / self-signed certs
      }
    };
    console.log("Veritabanına Bağlandı.")
    let pool = await sql.connect(config)
    let result = await pool.request()
      .query(query)  // subject is my database table name
    return result

  } catch (err) {
    console.log(err);
  }
}
module.exports = { queryDatabase }
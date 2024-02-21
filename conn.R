library(DBI)
library(RPostgres)

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "MDS",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "Ydth_2000"
)

if (dbIsValid(con)) {
  print("Connection successful!")
} else {
  print("Connection failed!")
}

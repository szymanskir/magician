#' Runs a temporary postgres instande in a docker container
#'
#' @param image_name name of the docker image with postgres to use
#'
#' @param code the code to execute that uses the postgres connection
#'
#' @param user user used for creating the postgres connection
#'
#' @param password password used for creating the postgres connection
#'
#' @param database database used for creating the postgres connection
#'
#' @param port port of the docker container to expose
#'
#' @details In the passed code you can refer to  the `con` variable
#' that stores the postgres connection. See examples
#'
#' @examples
#'
#' if (stevedore::docker_available()) {
#'   with_postgres_connection("postgres:12.10", {
#'     DBI::dbGetQuery(con, "select version();")
#'   })
#' }
#'
#' @export
#'
with_postgres_connection <- function(image_name, code, user = NULL, password = NULL, database = NULL, port = 5432) {
  require_package("DBI")
  require_package("RPostgres")

  user <- if(is.null(user)) Sys.getenv("POSTGRES_USER", "magician") else user
  password <- if(is.null(password)) Sys.getenv("POSTGRES_PASSWORD", "magician") else password
  database <- if(is.null(database)) Sys.getenv("POSTGRES_DB", "magician") else database

  with_docker_container(
    containers = list(
      postgres = run_container(
        image_name,
        env = list(
          "POSTGRES_PASSWORD" = password,
          "POSTGRES_USER" = user,
          "POSTGRES_DB" = database
        ),
        ports = port
      )
    ), {
      con <- retry({
        DBI::dbConnect(
          RPostgres::Postgres(),
          host = "localhost",
          user = user,
          password = password,
          port = get("postgres")$ports()$host_port[1]
        )},
        retry_time = 1,
        retry_count = 60
      )

      withr::with_db_connection(con = list(con = con), code)
    }
  )
}

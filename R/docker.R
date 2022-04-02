run_container <- function(image_name, ...) {
  docker_client <- stevedore::docker_client(quiet = TRUE)

  # prevent docker logs from appearing in the console
  utils::capture.output(
    container <- docker_client$container$run(
      image_name,
      detach = TRUE,
      ...
    ),
    file = NULL
  )

  container
}

with_docker_container <- function(containers, code) {
  stopifnot(is.list(containers))
  stopifnot(!is.null(names(containers)))
  stopifnot(all(vapply(containers, function(c) inherits(c, "docker_container"), FUN.VALUE = logical(1))))

  nme <- tempfile()
  get("attach", baseenv())(containers, name = nme, warn.conflicts = FALSE)
  on.exit({
    for (container in containers) container$remove(force = TRUE)
    detach(nme, character.only = TRUE)
  })

  force(code)
}

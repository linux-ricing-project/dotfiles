# função auxiliar que destrói todo o ambiente docker na máquina
  function docker_destroy_all(){
    yes | docker system prune -a
    yes | docker volume prune
  }
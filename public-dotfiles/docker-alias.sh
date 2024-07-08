# função auxiliar que destrói todo o ambiente docker na máquina
docker_destroy_all(){
  yes | docker system prune -a
  yes | docker volume prune
}

# Docker PS formatted to print only my most used fields
dps(){
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"
}
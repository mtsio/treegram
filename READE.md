docker build -t lab1:ruby ./
docker run -p 3000:3000 -v $(pwd):/app -it lab1:ruby
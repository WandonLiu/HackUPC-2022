let x = [ [0,1,2,3] , [3,2,1,0], [2,0,3,1] ];


fn is_valid(temp,cuadrante){

    if (temp[0]>=cuadrante[0] && temp[0]=cuadrante[2]  && temp[1]=20 &&  worker(0).y >=20 ) {
        return [20,40,20,40];
    } 
    
    //cuadrante 2
    else if(worker(0).x >=20 &&  worker(0).y <=20 ) {
        return  [20,40,0,20];
    }

    //cuadrante 3
    else if(worker(0).x <=20 &&  worker(0).y <=20 ) {
        return  [0,20,0,20];
    }

    //cuadrante 4
    return [0,20,20,40];

}


fn find(map,x,y){
    for i in map.workers {
        if (i.x == x && i.y == y){return false};
    }
    return true;
}

fn bfs(w,map,perm,worker_pos,x,cuadrante) {
    
    let visitados = [];
    let cola = [];
    let path = [];
    cola.push([worker(w).x, worker(w).y]);

    // Mientras hayan casillas a procesar
    while(cola.len > 0){
        let next_cola = cola.shift();

        visitados.push(next_cola);

        // comprobar si es bueno para ir
        if(map[next_cola[0]][next_cola[1]] != worker(w).color){ // comprobar si hay worker enemigo y si esta yendo un compañero
            if(((next_cola[0]-worker(w).x).abs() + (next_cola[1]-worker(w).y).abs() )== 1 && (find(map,next_cola[0],next_cola[1]))==false){
                return next_cola;
            }
            else if (going(next_cola,worker_pos)) {return next_cola;}
        }
        

        let found = false;


        let ff = (rand()%3).abs();
        for k in 0..4 {  
            let cc = x[ff][k];
            let temp = [perm[cc][0] + next_cola[0] , perm[cc][1] + next_cola[1]];

            if(  (w >=7 && is_valid(temp,cuadrante) )|| (w<7 && is_valid(temp,[0,40,0,40]) ) ) {
                
                let found = false;
                for j in 0..visitados.len {
                    if(visitados[j] == temp) {
                        found = true;
                        break;
                    }
                }
                // esta dentro del mapa y no es mia -> valida y voy
                
                if(found == false)  {
                    cola.push(temp);
                }
            }
            
        } 
 
    }
    
    let fallo = [worker(w).x, worker(w).y];
    fallo;

}


//  MAIN    //

if ("cuadrante" in memory == false) {

    memory.cuadrante = check_zona(map);

}


let perm = [[0,-1],[0,1],[1,0],[-1,0]];
//let perm2 = [[0,-1],[0,1],[1,0],[-1,0]];
//if (let cuadrante = [0,20,0,20];
    

// Busca el cuadrante en el que estamos
//if (first) {cuadrante = check_zona(map);}


let worker_pos = [];

let current = [];

worker_pos.clear();

if "tick" in memory == false {
    memory.tick = 0;
} 
else {
    memory.tick += 1;
}


if(memory.tick == 50) {
    memory.cuadrante = [0,40,0,40];
}


// For principal de control de todos los workers
for w in 0..8 {
    

    if(w == 7){
        if(worker(w).x > 35){
            worker(w).move_left();
        }
        else if (worker(w).x < 5){
            worker(w).move_right();
        }
        else if (worker(w).y > 35) {
            worker(w).move_down();
        }
        else if (worker(w).y < 5) {
            worker(w).move_up();
        }

        else if(worker(w).x < 35 && worker(w).x >=5 && worker(w).y <= 5 ){
            worker(w).move_right();
        }
        
        else if(worker(w).x >= 25 && worker(w).y < 35) {
            worker(w).move_up();
        }

        else if(worker(w).x <= 5 && worker(w).y > 5) {
            worker(w).move_down();
        }

        else if(worker(w).x <=35 && worker(w).x > 5 && worker(w).y > 5 ){
            worker(w).move_left();
        }

        current.push([worker(w).x,worker(w).y]);

    }
    // Lamada al bfs
    else {
        let fin = bfs(w,map,perm,worker_pos,x,memory.cuadrante);

    worker_pos.push(fin);

    current.push([worker(w).x,worker(w).y]);
    
    // If's de movimento
    

            if("cur" in memory == true && memory.cur[w] == current[w]) {
                let r = (rand() % 4).abs();
            switch r {
                0 => worker(w).move_up(),
                1 => worker(w).move_down(),
                2 => worker(w).move_right(),
                3 => worker(w).move_left(),
            }
            }
    
        
        
    if(worker(w).x < fin[0] && worker(w).x < 40 && find(map,worker(w).x+1,worker(w).y)){
        worker(w).move_right();
    }
   else if(worker(w).x > fin[0] && worker(w).x >=0 && find(map,worker(w).x-1,worker(w).y)){
        worker(w).move_left();
   }
   else if(worker(w).y < fin[1] && worker(w).x < 40 && find(map,worker(w).x,worker(w).y+1 ) ){
       worker(w).move_up();
   } 
   else if(worker(w).y > fin[1] && worker(w).x >= 0 && find(map,worker(w).x,worker(w).y-1)){ 
       worker(w).move_down();
   }
    }

   

    info(`worker ${w} finished`);
}
memory.cur = current;

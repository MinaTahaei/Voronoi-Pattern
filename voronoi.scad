// (c)2013 Felipe Sanches <juca@members.fsf.org>
// licensed under the terms of the GNU GPL version 3 (or later)

function normalize(v) = v/(sqrt(v[0]*v[0] + v[1]*v[1]));

module voronoi(points, L=200, thickness=1, round=5, nuclei=true){
	for (p=points){
		difference(){
			minkowski(){
			intersection_for(p1=points){
				if (p!=p1){
					translate((p+p1)/2 - normalize(p1-p) * (thickness+round))
					assign(angle=90+atan2(p[1]-p1[1], p[0]-p1[0])){
						rotate([0,0,angle])
						translate([-L,-L])
						square([2*L, L]);
					}
				}
			}
			circle(r=round, $fn=20);
			}
			if (nuclei)
			translate(p) circle(r=1, $fn=20);
		}
	}
}
////seed 2 5

module random_voronoi(n=10, nuclei=false, L=200, thickness=1, round=2, min=0, max=200, seed=10){ 

	x = rands(min, max, n, seed);
	y = rands(min, max, n, seed+1);

	for (i=[0:n-1]){
		difference(){
			minkowski(){
			intersection_for(j=[0:n-1]){
				if (i!=j){
					assign(p=[x[i],y[i]], p1=[x[j],y[j]]){
						translate((p+p1)/2 - normalize(p1-p) * (thickness+round))
						assign(angle=90+atan2(p[1]-p1[1], p[0]-p1[0])){
							rotate([0,0,angle])
							translate([-L,-L])
							square([2*L, L]);
						}
					}
				}
			}
			circle(r=round, $fn=20);
			}
			if (nuclei)
			translate([x[i],y[i]]) circle(r=1, $fn=20);
		}
	}
}

// example with an explicit list of points:
// point_set = [[0,0],[30,0],[20,10],[50,20],[15,30],[85,30],[35,30],[12,60], [45,50],[80,80],[20,-40],[-20,20],[-15,10],[-15,50]];
// voronoi(points=point_set, round=4, nuclei=false);

    // example with randomly generated set of points
    //translate([0,0,0]);
union () {
    linear_extrude(height=34)
    intersection() {
        translate([50,50])
        //max size of fraunhofer machine 110x123x90mm
        square(size = [110,123], center = false);
        random_voronoi(n=150, round=2, min=0, max=200);
    }
    translate([50,50,0])
    cube(size=[110,123,5], center=false);
}

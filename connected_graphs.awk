#!/usr/bin/awk -f
# NAME
#     connected_graphs.awk - show vertices of connected graphs in a set of edges
#
# SYNOPSIS
#     connected_graphs.awk [FILE...]
#
# DESCRIPTION
#     Takes edges as input and outputs vertices in each connected graph found
#     in the input.
#
# STDIN
#     The standard input will be used only if no file operands are specified, 
#     or if a file operand is '-'.
# 
# INPUT FILES
#     FILE
#         A list of undirected edges, one per line. Each line contains two
#         space- or tab-separated columns that contain the vertex names. The
#         order in which the vertices appear does not matter, and there may be
#         loops (i.e., the same vertex appears in both columns).
#     
# STDOUT
#     Each line of output lists the vertices in a connected graph.
#
# EXAMPLES
#     $ cat edges.txt
#     1 2
#     2 3
#     4 5
#     10 20
#     20 10
#     10 10
#     3 4
#     $ connected_graphs.awk edges.txt
#     20 10
#     1 2 3 4 5
#
# AUTHOR
#     Nathan Weeks <nathan.weeks@ars.usda.gov>

NF == 0 { next } # Skip empty lines. This may occur if the last line is empty, 
                 # resulting in a blank line being printed at some point
NF != 2 {print "ERROR: invalid input (line " NR "):" $0; exit}

# Neither vertex seen; add new connected graph
!($1 in lookup || $2 in lookup) {
    if ($1 == $2) {
        connected_graph[++count] = $1
        lookup[$1] = count
    } else {
        connected_graph[++count] = $1 " " $2
        lookup[$1] = count
        lookup[$2] = count
    }
    next
}

# first vertex is in a connected graph; add second vertex to the graph
$1 in lookup && !($2 in lookup) {
    connected_graph[lookup[$1]] = connected_graph[lookup[$1]] " " $2
    lookup[$2] = lookup[$1]
    next
}

# second vertex is in a connected graph; add first vertex to the graph
!($1 in lookup) && $2 in lookup {
    connected_graph[lookup[$2]] = connected_graph[lookup[$2]] " " $1
    lookup[$1] = lookup[$2]
    next
}

# If we made it this far, both vertices are in connected graphs (i.e., "$1 in
# lookup && $2 in lookup").
lookup[$1] != lookup[$2] { # if they are not the same connected graph
    # absorb second connected graph into first
    connected_graph[lookup[$1]] = connected_graph[lookup[$1]] " " \
                                  connected_graph[lookup[$2]]
    
    # delete the absorbed connected graph, and change lookup table entries for
    # all vertices that were in it to point to the first connected graph
    split(connected_graph[lookup[$2]], vertices)
    delete connected_graph[lookup[$2]] 
    for (vertex in verticies)
        lookup[vertex] = lookup[$1]
}

# print each connected graph
END { for(graph in connected_graph) print connected_graph[graph] }

cache_project_list() {
    local plen
    local pnum
    local pname
    local idx
    gh project list --format json --owner openssl > $TEMPDIR/projects.json 
    plen=$(jq '.projects | length' $TEMPDIR/projects.json)
    let plen=$plen-1
    for i in $(seq 0 1 $plen)
    do
        export idx=$i
        pname=$(jq -r '.projects[$ENV.idx | tonumber] | .title' $TEMPDIR/projects.json)
        pnum=$(jq '.projects[$ENV.idx | tonumber] | .number' $TEMPDIR/projects.json)
        git config ghprojects."$pname".num $pnum
    done
}

lookup_project() {
    local pname=$*
    git config --get-regexp ghprojects > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
       cache_project_list
    fi
    echo $(git config --get ghprojects."$pname".num)
}


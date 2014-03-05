function blockinfo()
end

function unitinfo()
end

function eventdata()
end

function indexbytime()
end

function timebyindex()
end


function cutst(st::TimePoints,begintime::Real,endtime::Real)
  st[(begintime .<= st) & (st .< endtime)]
end
cutst(st::TimePoints,begin_end::TimePoints) = cutst(st,begin_end[1],begin_end[end])

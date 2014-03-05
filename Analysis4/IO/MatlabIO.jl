module MatlabIO

using MAT

function read(filename)
   vars = matread(filename);
   vars
end

end # module

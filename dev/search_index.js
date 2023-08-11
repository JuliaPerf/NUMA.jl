var documenterSearchIndex = {"docs":
[{"location":"examples/numa_first_touch/#Example:-NUMA-first-touch-policy","page":"First-touch policy","title":"Example: NUMA first-touch policy","text":"","category":"section"},{"location":"examples/numa_first_touch/","page":"First-touch policy","title":"First-touch policy","text":"In the following example, parts of an array are (equally) distributed among 8 NUMA nodes of a system, because different threads - pinned to cores in different NUMA domains via ThreadPinning.jl - perform the first touch, i.e. the first write operation.","category":"page"},{"location":"examples/numa_first_touch/","page":"First-touch policy","title":"First-touch policy","text":"# Example is designed for a system with 8 NUMA domains.\n# Run as: julia --project -t 8 numa_first_touch.jl [N]\nusing NUMA\nusing ThreadPinning\nusing Base.Threads\n\n@assert nthreads() >= 8\npinthreads(:numa)\n\n# allocate a large array (you might need to adjust the size for your system)\nN = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7\nx = Vector{Float64}(undef, N);\nprintln(\"Array size: \", Base.format_bytes(sizeof(x)))\n\n# \"touch\" contiguous parts of the array from different threads\n# (which are pinned to cores in different NUMA domains)\n@threads :static for i in eachindex(x)\n    x[i] = threadid()\nend\n\n# query on which node the memory pages are located\nblocksize = length(x) ÷ nnumanodes()\nfor i in 1:8\n    println(\"Block $i on NUMA node \", which_numa_node(x, (i-1)*blocksize+1))\nend","category":"page"},{"location":"examples/numa_first_touch/","page":"First-touch policy","title":"First-touch policy","text":"$ julia --project -t 8 numa_first_touch.jl\nArray size: 76.294 MiB\nBlock 1 on NUMA node 1\nBlock 2 on NUMA node 2\nBlock 3 on NUMA node 3\nBlock 4 on NUMA node 4\nBlock 5 on NUMA node 5\nBlock 6 on NUMA node 6\nBlock 7 on NUMA node 7\nBlock 8 on NUMA node 8","category":"page"},{"location":"examples/querying/#Querying-NUMA-properties","page":"Querying NUMA properties","title":"Querying NUMA properties","text":"","category":"section"},{"location":"examples/querying/","page":"Querying NUMA properties","title":"Querying NUMA properties","text":"Basic information can be readily queried:","category":"page"},{"location":"examples/querying/","page":"Querying NUMA properties","title":"Querying NUMA properties","text":"julia> numa_available()\ntrue\n\njulia> nnumanodes()\n8\n\njulia> ncpus()\n128\n\njulia> current_cpu()\n22\n\njulia> current_numa_node() # NUMA node IDs start at zero! (so this result means the second node)\n1\n\njulia> numa_get_membind()\nBitmask (trunc): 11111111","category":"page"},{"location":"examples/querying/","page":"Querying NUMA properties","title":"Querying NUMA properties","text":"To get a nice visualization of the system topology it is highly recommended to use ThreadPinning.jl and threadinfo(; groupby=:numa) specifically.","category":"page"},{"location":"examples/querying/","page":"Querying NUMA properties","title":"Querying NUMA properties","text":"(Image: threadinfo_numa)","category":"page"},{"location":"refs/libnuma/#LibNuma","page":"LibNuma","title":"LibNuma","text":"","category":"section"},{"location":"refs/libnuma/","page":"LibNuma","title":"LibNuma","text":"warning: Important note\nThis is the low-level wrapper around libnuma and, in most cases, shouldn't be used directly!","category":"page"},{"location":"refs/libnuma/#Index","page":"LibNuma","title":"Index","text":"","category":"section"},{"location":"refs/libnuma/","page":"LibNuma","title":"LibNuma","text":"Pages   = [\"libnuma.md\"]\nOrder   = [:function, :type]","category":"page"},{"location":"refs/libnuma/#References","page":"LibNuma","title":"References","text":"","category":"section"},{"location":"refs/libnuma/","page":"LibNuma","title":"LibNuma","text":"Modules = [NUMA]\nPages   = [\"LibNuma.jl\"]","category":"page"},{"location":"refs/api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"refs/api/","page":"API","title":"API","text":"warning: Important note\nIn contrast to the C-interface, we use one-based indices for the \"high-level\" API. Hence, the first NUMA node is NUMA node 1 (not 0). Consequently, on a system with 8 NUMA domains, numa_max_node() returns 8 (not 7).","category":"page"},{"location":"refs/api/#Index","page":"API","title":"Index","text":"","category":"section"},{"location":"refs/api/","page":"API","title":"API","text":"Pages   = [\"api.md\"]\nOrder   = [:function, :type]","category":"page"},{"location":"refs/api/#References-Add-ons","page":"API","title":"References - Add-ons","text":"","category":"section"},{"location":"refs/api/","page":"API","title":"API","text":"Modules = [NUMA]\nPages   = [\"julia_extra.jl\", \"julia_arrayalloc.jl\"]","category":"page"},{"location":"refs/api/#NUMA.current_cpu-Tuple{}","page":"API","title":"NUMA.current_cpu","text":"Returns the ID (starting at zero) of the CPU-thread on which the calling Julia thread is currently running on.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.current_cpus-Tuple{}","page":"API","title":"NUMA.current_cpus","text":"Returns the IDs (starting at zero) of the CPU-threads on which the Julia threads are currently running on.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.current_numa_node-Tuple{}","page":"API","title":"NUMA.current_numa_node","text":"Returns the NUMA node associated with the CPU-thread on which the calling Julia thread is currently running on.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.current_numa_nodes-Tuple{}","page":"API","title":"NUMA.current_numa_nodes","text":"Returns the NUMA nodes associated with the CPU-threads on which the Julia threads are currently running on.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.ncpus-Tuple{}","page":"API","title":"NUMA.ncpus","text":"Returns the number CPU-threads available on this system.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.nnumanodes-Tuple{}","page":"API","title":"NUMA.nnumanodes","text":"Returns the number of NUMA nodes available on this system.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.which_numa_node","page":"API","title":"NUMA.which_numa_node","text":"which_numa_node(arr::AbstractArray) -> Int64\nwhich_numa_node(arr::AbstractArray, i; kwargs...) -> Int64\n\n\nQuery on which NUMA node the given array is allocated (assuming that it is allocated on a single node).\n\nTechnically only the address of a single element is checked (by default the first one). The optional second integer argument can be used to specify this element.\n\nThe optional keyword argument variant can be used to switch between methods used to determine the NUMA node. Valid options are :move_pages (default) and :get_mempolicy.\n\nNote: Returned NUMA node IDs start at zero!\n\n\n\n\n\n","category":"function"},{"location":"refs/api/#NUMA.which_numa_node-Union{Tuple{Ptr{T}}, Tuple{T}} where T","page":"API","title":"NUMA.which_numa_node","text":"which_numa_node(ptr::Ptr{T}; variant) -> Int64\n\n\nQuery on which NUMA node the page associated with the given memory address (pointer) is located.\n\nThe optional keyword argument variant can be used to switch between methods used to determine the NUMA node. Valid options are :move_pages (default) and :get_mempolicy.\n\nNote: Returned NUMA node IDs start at zero!\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numalocal-Tuple{}","page":"API","title":"NUMA.numalocal","text":"numalocal() -> NUMA.NUMALocal\n\n\nReturns an array initializer that represents the local NUMA node. To be used as, e.g., Vector{Float64}(numalocal(), 1024).\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numanode-Tuple{Integer}","page":"API","title":"NUMA.numanode","text":"numanode(i::Integer) -> NUMA.NUMANode\n\n\nReturns an array initializer that represents a specific NUMA node. To be used as, e.g., Vector{Float64}(numanode(1), 1024).\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#References-Bitmask","page":"API","title":"References - Bitmask","text":"","category":"section"},{"location":"refs/api/","page":"API","title":"API","text":"Modules = [NUMA]\nPages   = [\"julia_bitmask.jl\"]","category":"page"},{"location":"refs/api/#NUMA.Bitmask","page":"API","title":"NUMA.Bitmask","text":"Represents a bit mask. To be used to indicate, e.g., node masks or cpu masks.\n\nExample:\n\njulia> bm = Bitmask()\nBitmask (trunc): 00000000\n\njulia> fill!(bm, 1); bm\nBitmask (trunc): 11111111\n\njulia> bm[2] = 0; bm\nBitmask (trunc): 11111101\n\njulia> numa_set_membind(bm)\n\njulia> numa_get_membind()\nBitmask (trunc): 11111101\n\n\n\n\n\n","category":"type"},{"location":"refs/api/#References","page":"API","title":"References","text":"","category":"section"},{"location":"refs/api/","page":"API","title":"API","text":"Modules = [NUMA]\nPages   = [\"julia.jl\"]","category":"page"},{"location":"refs/api/#NUMA.numa_allocate_cpumask-Tuple{}","page":"API","title":"NUMA.numa_allocate_cpumask","text":"numa_allocate_cpumask() -> Bitmask\n\n\nReturns a bitmask of a size equal to the kernel's cpu mask. In other words, large enough to represent all cpus.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_allocate_nodemask-Tuple{}","page":"API","title":"NUMA.numa_allocate_nodemask","text":"numa_allocate_nodemask() -> Bitmask\n\n\nReturns a bitmask of a size equal to the kernel's node mask. In other words, large enough to represent all nodes.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_available-Tuple{}","page":"API","title":"NUMA.numa_available","text":"numa_available() -> Bool\n\n\nIs this a NUMA system?\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_bitmask_alloc","page":"API","title":"NUMA.numa_bitmask_alloc","text":"numa_bitmask_alloc() -> Bitmask\nnuma_bitmask_alloc(n::Integer) -> Bitmask\n\n\nAllocates a bitmask structure and its associated bit mask. The memory allocated for the bit mask contains enough words (type UInt64) to contain n bits. If n isn't provided, nnumanodes() is used.\n\nThe bit mask is zero-filled.\n\n\n\n\n\n","category":"function"},{"location":"refs/api/#NUMA.numa_bitmask_clearall!-Tuple{Bitmask}","page":"API","title":"NUMA.numa_bitmask_clearall!","text":"numa_bitmask_clearall!(bm::Bitmask)\n\n\nSet all bits in the given Bitmask to zero.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_bitmask_clearbit!-Tuple{Bitmask, Integer}","page":"API","title":"NUMA.numa_bitmask_clearbit!","text":"numa_bitmask_clearbit!(bm::Bitmask, n::Integer)\n\n\nClear the n-th bit of the given Bitmask.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_bitmask_setall!-Tuple{Bitmask}","page":"API","title":"NUMA.numa_bitmask_setall!","text":"numa_bitmask_setall!(bm::Bitmask)\n\n\nSet all bits in the given Bitmask to one.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_bitmask_setbit!-Tuple{Bitmask, Integer}","page":"API","title":"NUMA.numa_bitmask_setbit!","text":"numa_bitmask_setbit!(bm::Bitmask, n::Integer)\n\n\nSet the n-th bit of the given Bitmask.\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_get_membind-Tuple{}","page":"API","title":"NUMA.numa_get_membind","text":"numa_get_membind() -> Bitmask\n\n\nReturns the mask of nodes from which memory can currently be allocated\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_get_mems_allowed-Tuple{}","page":"API","title":"NUMA.numa_get_mems_allowed","text":"numa_get_mems_allowed() -> Bitmask\n\n\nReturns the mask of nodes from which the process is allowed to allocate memory in it's current cpuset context\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_max_node-Tuple{}","page":"API","title":"NUMA.numa_max_node","text":"numa_max_node() -> Int64\n\n\nHighest node number available on the system\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_max_possible_node-Tuple{}","page":"API","title":"NUMA.numa_max_possible_node","text":"numa_max_possible_node() -> Int64\n\n\nNumber of the highest possible node in a system\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_node_of_cpu","page":"API","title":"NUMA.numa_node_of_cpu","text":"numa_node_of_cpu() -> Int64\nnuma_node_of_cpu(cpuid::Integer) -> Int64\n\n\nReturns the NUMA node that the cpu with the given id (starting at zero) belongs to.\n\n\n\n\n\n","category":"function"},{"location":"refs/api/#NUMA.numa_node_size","page":"API","title":"NUMA.numa_node_size","text":"numa_node_size(\n\n) -> NamedTuple{(:memtot, :memfree), Tuple{Int64, Int64}}\nnuma_node_size(\n    node::Integer\n) -> NamedTuple{(:memtot, :memfree), Tuple{Int64, Int64}}\n\n\nReturns a named tuple holding the total memory and free memory of the given NUMA node. If no node index is provided as an argument, current_numa_node() is used.\n\n\n\n\n\n","category":"function"},{"location":"refs/api/#NUMA.numa_num_possible_nodes-Tuple{}","page":"API","title":"NUMA.numa_num_possible_nodes","text":"numa_num_possible_nodes() -> Int64\n\n\nReturns the size of kernel's node mask, i.e. large enough to represent the maximum number of nodes that the kernel can handle\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_pagesize-Tuple{}","page":"API","title":"NUMA.numa_pagesize","text":"numa_pagesize() -> Int64\n\n\nReturns the number of bytes in a page\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_preferred-Tuple{}","page":"API","title":"NUMA.numa_preferred","text":"numa_preferred() -> Int64\n\n\nPreferred NUMA node of the current task\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_set_localalloc-Tuple{}","page":"API","title":"NUMA.numa_set_localalloc","text":"numa_set_localalloc()\n\n\nSets the memory allocation policy for the calling task to local allocation\n\n\n\n\n\n","category":"method"},{"location":"refs/api/#NUMA.numa_set_membind-Tuple{Bitmask}","page":"API","title":"NUMA.numa_set_membind","text":"numa_set_membind(bm::Bitmask)\n\n\nSets the memory allocation mask. The task will only allocate memory from the nodes set in the given nodemask. Passing an empty nodemask or a nodemask that contains nodes other than those in the mask returned by numa_get_mems_allowed() will result in an error.\n\n\n\n\n\n","category":"method"},{"location":"examples/numa_node_alloc/#Example:-Allocate-on-NUMA-nodes","page":"Allocate on NUMA nodes","title":"Example: Allocate on NUMA nodes","text":"","category":"section"},{"location":"examples/numa_node_alloc/#Specific-node(s)","page":"Allocate on NUMA nodes","title":"Specific node(s)","text":"","category":"section"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"In the following example, we explicitly allocate an array on a specific NUMA node.","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"julia> using NUMA, Random\n\njulia> x = Vector{Float64}(numanode(3), 10); rand!(x);\n\njulia> which_numa_node(x)\n3","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"Below we demonstrate the same for a bunch of arrays:","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"# Run with as many threads as there are NUMA domains, e.g.:\n#   julia --project -t 8 numa_node_alloc.jl [power]\nusing NUMA\nusing ThreadPinning\nusing Base.Threads\nusing Random\n\npinthreads(:random) # to demonstrate that the pinning is irrelevant\n\nN = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7 # optional cmdline arg\n\nxs = Vector{Vector{Float64}}(undef, nthreads());\n\ntargets = 1:nnumanodes()\nfor i in 1:nthreads()\n    xs[i] = Vector{Float64}(numanode(targets[i]), N)\nend\n\nfirst_touch_from = current_numa_nodes()\n@threads :static for i in 1:nthreads()\n    rand!(xs[i])\nend\n\nprintln(\"Size of each array: \", Base.format_bytes(sizeof(Float64) * N))\nprintln(\"Requested memory for arrays from nodes:\\t\", collect(targets))\nprintln(\"Filled the arrays from (random) nodes:\\t\", first_touch_from)\nprintln(\"Queried locations of memory pages:\\t\", which_numa_node.(xs))","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"$ julia --project -t 8 numa_node_alloc.jl\nSize of each array: 76.294 MiB\nRequested memory for arrays from nodes: [1, 2, 3, 4, 5, 6, 7, 8]\nFilled the arrays from (random) nodes:  [7, 2, 8, 6, 3, 6, 1, 1]\nQueried locations of memory pages:      [1, 2, 3, 4, 5, 6, 7, 8]","category":"page"},{"location":"examples/numa_node_alloc/#Local-node(s)","page":"Allocate on NUMA nodes","title":"Local node(s)","text":"","category":"section"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"We can also allocate on the local NUMA node, that is, the node closest to the CPU-thread/core we're currently running on.","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"julia> using NUMA, ThreadPinning, Random\n\njulia> numa_node_of_cpu(32)\n2\n\njulia> pinthread(32);\n\njulia> current_cpu()\n32\n\njulia> current_numa_node()\n2\n\njulia> x = Vector{Float64}(numalocal(), 10); rand!(x);\n\njulia> which_numa_node(x)\n2","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"Demonstrating the same for multiple threads pinned to separate NUMA domains (in random order):","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"# Run with as many threads as there are NUMA domains, e.g.:\n#   julia --project -t 8 numa_node_alloc_local.jl [power]\nusing NUMA\nusing ThreadPinning\nusing Base.Threads\nusing Random\n\n@assert nthreads() == nnumanodes()\n\n# pin each thread to a random NUMA domain but each to a different one\npinthreads(shuffle!(first.(cpuids_per_numa())))\n\nN = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7 # optional cmdline arg\n\nxs = Vector{Vector{Float64}}(undef, nthreads());\n\n@threads :static for i in 1:nthreads()\n    xs[i] = Vector{Float64}(numanode(current_numa_node()), N) # works\n    # xs[i] = Vector{Float64}(numalocal(), N) # doesn't quite work?!\nend\n\nfirst_touch_from = shuffle(current_numa_nodes()) # randomize\n@threads :static for i in 1:nthreads()\n    rand!(xs[first_touch_from[i]])\nend\n\nprintln(\"Size of each array: \", Base.format_bytes(sizeof(Float64) * N))\nprintln(\"Requested memory for arrays from nodes:\\t\", current_numa_nodes())\nprintln(\"Filled the arrays from (random) nodes:\\t\", first_touch_from)\nprintln(\"Queried locations of memory pages:\\t\", which_numa_node.(xs))","category":"page"},{"location":"examples/numa_node_alloc/","page":"Allocate on NUMA nodes","title":"Allocate on NUMA nodes","text":"$ julia --project -t 8 numa_node_alloc_local.jl\nSize of each array: 76.294 MiB\nRequested memory for arrays from nodes: [1, 3, 5, 8, 7, 6, 2, 4]\nFilled the arrays from (random) nodes:  [8, 5, 7, 6, 1, 3, 2, 4]\nQueried locations of memory pages:      [1, 3, 5, 8, 7, 6, 2, 4]","category":"page"},{"location":"#NUMA.jl","page":"NUMA","title":"NUMA.jl","text":"","category":"section"},{"location":"","page":"NUMA","title":"NUMA","text":"NUMA.jl provides tools for querying and controlling NUMA (non-uniform memory access) policies in Julia applications. It is based on libnuma.","category":"page"},{"location":"#Install","page":"NUMA","title":"Install","text":"","category":"section"},{"location":"","page":"NUMA","title":"NUMA","text":"NUMA.jl is registered in Julia's General package registry. You can add it to your Julia environment by executing","category":"page"},{"location":"","page":"NUMA","title":"NUMA","text":"using Pkg\nPkg.add(\"NUMA\")","category":"page"},{"location":"#Why-care?","page":"NUMA","title":"Why care?","text":"","category":"section"},{"location":"","page":"NUMA","title":"NUMA","text":"Because not caring about NUMA can negatively impact performance, in particular for computations that are limited by memory-bandwidth. To give a simple example, consider a DAXPY kernel, which operates on two Julia arrays. We benchmark the memory bandwidth (i.e. how fast we can read and write data) of this kernel under two different circumstances: The arrays are allocated in the local NUMA node or in a distant NUMA node. By \"local\" we mean local to the CPU core that is hosting the Julia thread performing the computation. The benchmark results - on a system with 2x AMD Milan 7763 CPUs and 8 NUMA domains - are:","category":"page"},{"location":"","page":"NUMA","title":"NUMA","text":"Array in local NUMA node:       37.19 GB/s\nArray in distant NUMA node:     23.24 GB/s","category":"page"},{"location":"","page":"NUMA","title":"NUMA","text":"Note that the memory bandwidth is 60% higher for the local case. This NUMA effect is even more pronounced when using multithreading (example code).","category":"page"},{"location":"","page":"NUMA","title":"NUMA","text":"Arrays in thread-local NUMA nodes:      286.08 GB/s\nArrays all in first NUMA node (naive):  38.7 GB/s","category":"page"},{"location":"","page":"NUMA","title":"NUMA","text":"Here, we see a ~7.4x improvement of the memory bandwidth (i.e. ∝ the number of NUMA domains) .","category":"page"},{"location":"#Useful-background-information","page":"NUMA","title":"Useful background information","text":"","category":"section"},{"location":"","page":"NUMA","title":"NUMA","text":"NUMA (Non-Uniform Memory Access): An Overview (by Christoph Lameter)\nWhat is NUMA? (from the linux kernel documentation)\nNUMA (from the HPC wiki)","category":"page"},{"location":"#Acknowledgements","page":"NUMA","title":"Acknowledgements","text":"","category":"section"},{"location":"","page":"NUMA","title":"NUMA","text":"ArrayAllocators.jl and specifically NumaAllocators.jl has served as an inspiration (and provides similar functionality).","category":"page"}]
}

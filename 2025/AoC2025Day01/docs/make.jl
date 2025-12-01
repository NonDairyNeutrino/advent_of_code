using AoC2025Day01
using Documenter

DocMeta.setdocmeta!(AoC2025Day01, :DocTestSetup, :(using AoC2025Day01); recursive=true)

makedocs(;
    modules=[AoC2025Day01],
    authors="Nate Chapman <nate@symbolicmind.ai> and contributors",
    sitename="AoC2025Day01.jl",
    format=Documenter.HTML(;
        canonical="https://nondairyneutrino.github.io/AoC2025Day01.jl",
        edit_link="trunk",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/nondairyneutrino/AoC2025Day01.jl",
    devbranch="trunk",
)

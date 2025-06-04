if isinteractive()
    try
        @eval using VimBindings
        using Revise

        # using InTheRed        # https://github.com/mcabbott/InTheRed.jl.git
        # using UnicodePlots    # https://github.com/JuliaPlots/UnicodePlots.jl

        using OhMyREPL
        OhMyREPL.input_prompt!(" ", :green)
        # OhMyREPL.output_prompt!(" ", :blue)
        colorscheme!("Distinguished")
    catch e
        @warn "Error initializing: " exception = (e, catch_backtrace())
    end
end

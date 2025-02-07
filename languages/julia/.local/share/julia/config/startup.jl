try
        using Revise
        using OhMyREPL

        OhMyREPL.input_prompt!(" ", :green)
        OhMyREPL.output_prompt!(" ", :blue)
        colorscheme!("Base16MaterialDarker")
catch e
        @warn "Error initializing Revise" exception = (e, catch_backtrace())
end

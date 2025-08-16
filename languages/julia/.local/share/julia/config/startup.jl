# atreplinit() do _
#     @async begin
#         @eval using Suppressor
#         @eval @suppress using AbbreviatedStackTraces
#
#         @eval using OhMyREPL
#         @eval using Revise
#     end
# end

@time begin
    if isinteractive()
        try
            @eval using Revise

            @eval using VimBindings
            # VimBindings.Config.system_clipboard!(true)

            @eval using OhMyREPL
            @eval OhMyREPL.input_prompt!(" ", :green)
            @eval OhMyREPL.colorscheme!("Distinguished")

            # @eval using Suppressor
            # @eval @suppress using AbbreviatedStackTraces

            # using InTheRed        # https://github.com/mcabbott/InTheRed.jl.git
            # using UnicodePlots    # https://github.com/JuliaPlots/UnicodePlots.jl
        catch e
            @warn "Error initializing: " exception = (e, catch_backtrace())
        end
    end
end

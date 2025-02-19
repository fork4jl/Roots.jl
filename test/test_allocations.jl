using Test
import BenchmarkTools

@testset "solve: zero allocations" begin
    fs = (sin, cos, x -> -sin(x))
    x0 = (3, 4)
    Ms = (
        Order0(),
        Order1(),
        Order2(),
        Order5(),
        Order8(),
        Order16(),
        Roots.Order1B(),
        Roots.Order2B(),
        Roots.Bisection(),
        Roots.A42(),
        Roots.AlefeldPotraShi(),
        Roots.Brent(),
        Roots.Ridders(),
        Roots.ITP(),
    ) # not FalsePosition()
    Ns = (Roots.Newton(), Roots.Halley(), Roots.Schroder())
    for M in Ms
        @test BenchmarkTools.@ballocated(solve(ZeroProblem($fs, $x0), $M)) == 0
    end
    for M in Ns
        @test BenchmarkTools.@ballocated(solve(ZeroProblem($fs, $x0), $M)) == 0
    end

    # issue #323, test allocations with parameter
    f(x, p) = x^2 - p
    x0 = (1.0, 2.0)
    p = 2.0
    for M in Ms
        @test BenchmarkTools.@ballocated(solve(ZeroProblem($f, $x0), $M, $p)) == 0
        @test BenchmarkTools.@ballocated(solve(ZeroProblem($f, $x0), $M; p=$p)) == 0
    end
end

@testset "simple: zero allocations" begin
    @test BenchmarkTools.@ballocated(Roots.bisection(sin, 3, 4)) == 0
    @test BenchmarkTools.@ballocated(Roots.secant_method(sin, 3)) == 0
    @test BenchmarkTools.@ballocated(Roots.muller(sin, 2.9, 3.0, 3.1)) == 0
    @test BenchmarkTools.@ballocated(Roots.newton((sin, cos), 3)) == 0
    @test BenchmarkTools.@ballocated(Roots.dfree(sin, 3)) == 0
end

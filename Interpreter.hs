module Interpreter (interpret) where

inside :: String -> Int -> String

inside ('}':_) 1 = []
inside ('{':ax) z = '{':(inside ax (z+1))
inside ('}':ax) z = '}':(inside ax (z-1))
inside (a:ax) z = a:(inside ax z)

outside :: String -> Int -> String

outside ('}':ax) 1 = ax
outside ('{':ax) z = '{':(outside ax (z+1))
outside ('}':ax) z = '}':(outside ax (z-1))
outside (a:ax) z = a:(outside ax z)


f :: String -> ([Integer], [Integer]) -> ([Integer], [Integer])

f [] x = x

f ('(':ax) ((l:lx), rx) = f ax (((l-1):lx), rx)
f ('(':ax) ([], rx) = f ax ([-1], rx)
f (')':ax) ((l:lx), rx) = f ax (((l+1):lx), rx)
f (')':ax) ([], rx) = f ax ([1], rx)

f (']':ax) ((l:lx), (r:rx)) = f ax ((l:r:lx), rx)
f (']':ax) ([], rx) = f (']':ax) ([0], rx)
f (']':ax) (lx, []) = f (']':ax) (lx, [0])
f ('[':ax) ((l:r:lx), rx) = f ax ((l:lx), (r:rx))
f ('[':ax) ((l:[]), rx) = f ('[':ax) (l:0:[], rx)
f ('[':ax) ([], rx) = f ('[':ax) ([0,0], rx)

f ('>':ax) (lx, (r:rx)) = f ax ((r:lx), rx)
f ('>':ax) (lx, []    ) = f ax ((0:lx), [])
f ('<':ax) ((l:lx), rx) = f ax (lx, (l:rx))
f ('<':ax) ([],     rx) = f ax ([], (0:rx))

f ('{':ax) (l:lx, rx) = f (outside ax 1) (run (inside ax 1) l (f (inside ax 1) (l:lx, rx)))
f ('{':ax) ([], rx) = f ('{':ax) ([0], rx)

run :: String -> Integer -> ([Integer], [Integer]) -> ([Integer],[Integer])
run s t ([], rx) = run s t ([0], rx)
run s t (l:lx, rx)
 | t == l = (l:lx, rx)
 | t /= l = run s t (f s (l:lx, rx))

padding :: String -> (Int, Int) -> (Int, Int)

padding [] x = x
padding ('{':sx) (a,b) = padding sx (a,b+1)
padding ('}':sx) (a,0) = padding sx (a+1,0)
padding ('}':sx) (a,b) = padding sx (a,b-1)
padding (_:sx)   (a,b) = padding sx (a,b)

pad :: String -> String

pad x = (replicate (fst$padding x (0,0)) '{') ++ x ++ (replicate (snd$padding x (0,0)) '}')

trim :: [Integer] -> [Integer]

trim [] = []
trim (0:x) = trim x
trim x
 | last x == 0 = trim$ init x
 | otherwise   = x

interpret :: String -> [Integer] -> [Integer]

interpret source input = trim$ (\(a,b) -> (reverse a) ++ b)(f (pad source) ((trim$ reverse input), []))

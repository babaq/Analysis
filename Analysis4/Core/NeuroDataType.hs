module Analysis.Base where

type TimePoints = [Double]

data Spike = Spike{channel::Int,
fs::Double,
value::[Double],
time::Double,
delay::Double,
sort::Int} deriving (Show)

module Analysis.Core
# Neural Data Type Definations
using Base

## Base Type ##
type Vector3{T}
	x::T
	y::T
	z::T
end

type UnitError <: Exception

end

## Neural Type ##
type Channel
	name::String
	index::Uint64
	coordinate::Vector3{Float64}
	signal # Analog or Discrete
end

type ChannelCluster
	name::String
	channels::Vector{Channel}
end

type AnalogSignal
	channel::Uint64
	fs::Float64
	value::Vector{Float64}
	starttime::Float64
end

# ActionPotential or Spike
type Segment
	channel::Uint64
	fs::Float64
	value::Vector{Float64}
	time::Float64
	delay::Float64
	sortid
end

type SegmentSeries
	name::String
	segments::Vector{Segment}
end

type Event
	name::String
	value
	time::Float64
end

type EventSeries
	name::String
	events::Vector{Event}
end

type Epoch
	name::String
	time::Float64
	duration::Float64
	value
end

type EpochSeries
	name::String
	epochs::Vector{Epoch}
end

# Cell or Unit
type Unit
	name::String
	type
	spiketrain::Vector{Float64}
end

type UnitAssemble
	name::String
	units::Vector{Unit}
end

type Block
	name::String
	source
	duration
	description
	setting::Dict
	eventseriesgroup::Vector{EventSeries}
	epochseriesgroup::Vector{EpochSeries}
	unitassemblegroup::Vector{UnitAssemble}
	channelclustergroup::Vector{ChannelCluster}
	segmentseriesgroup::Vector{SegmentSeries}
end

type Subject
	name::String
	description
	gender
	age
	height
	weight
	recordsessions::Vector{RecordSession}
end

type RecordSession
	name::String
	description
	region
	experimenter
	date
	blocks::Vector{Block}
end

type Experiment
	name
	description
	subjects::Vector{Subject}
end

end # end of module
defmodule DataLoader do
  @moduledoc false
  def parseDate([date , time , lat , lon , result]) do
    newDate = date<>time |> String.replace("-", "") |> String.replace(":", "")
    {newDate, _} = Integer.parse(newDate)
    {lat, _} = Float.parse(lat)
    {lon, _} = Float.parse(lon)
    {result, _} = Float.parse(result)
    [newDate , {lat, lon} , result]
  end

  def parseLine(line) do
    parts = line  |> String.split(",") |> parseDate
  end

  def parse(filename \\ "pollution.csv") do
    list = File.read!(filename) |> String.split
    list = Enum.map(list, fn (x) -> parseLine(x) end)
list = Enum.map(list, fn (x) -> identifyStations(x) end)
  end

  def identifyStations(elem) do
    [_, {lat, lon}, _] = elem
    station_name = "station_#{lat}_#{lon}"
    [station_name | elem]
  end

  def
end

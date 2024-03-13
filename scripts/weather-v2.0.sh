#!/bin/bash

# v2.0 Closebox73
# This script is to get weather data from openweathermap.com in the form of a json file
# so that conky will still display the weather when offline even though it doesn't up to date

# Variables
# get your city id at https://openweathermap.org/find and replace
city_id=1809461

# replace with yours
api_key=16b3513d8e0eb9ba017fc2891725bf74

# choose between metric for Celcius or imperial for fahrenheit
unit=metric

# i'm not sure it will support all languange, 
lang=en

# Main command
url="api.openweathermap.org/data/2.5/weather?id=${city_id}&appid=${api_key}&cnt=5&units=${unit}&lang=${lang}"
result=$(curl ${url} -s)

temparature=$(echo $result | jq '.main.temp' | awk '{print int($1+0.5)}')
city=$(echo $result | jq -r '.name')
icon=$(echo $result | jq -r '.weather[0].icon')
description=$(echo $result | jq -r '.weather[0].description' | sed "s|\<.|\U&|g")
windSpeed=$(echo $result | jq '.wind.speed')
humidity=$(echo $result | jq '.main.humidity')

# 数据写入缓存
expire=3600
cr set "temparature" "$temparature" "$expire"
cr set "city" "$city" "$expire"
cr set "icon" "$icon" "$expire"
cr set "description" "$description" "$expire"
cr set "windSpeed" "$windSpeed" "$expire"
cr set "humidity" "$humidity" "$expire"

exit

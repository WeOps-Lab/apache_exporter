#!/bin/bash

for version in v2-4; do
    # standalone
    standalone_output_file="standalone_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g;" standalone.tpl > ../standalone/${standalone_output_file}
done


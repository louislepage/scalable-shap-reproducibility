#-------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#-------------------------------------------------------------
#/bin/bash

echo "Beginning download of Adults"

# Change directory to data.
if [[ pwd != *"data"* ]]; then
    cd "$REPRO_BASE_PATH/data"
fi




# Download file if not already downloaded.
if [[ ! -f "adult/Adult.csv" ]]; then
    mkdir -p adult/
    #the download is very slow
    wget -nv -O adult/Adult.csv https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data
    if [[ ! -f "adult/Adult.csv" ]]; then
      sed -i '$d' adult/Adult.csv; # fix empty line at end of file
      echo "Successfully downloaded Adult dataset."
    else
      echo "Could not download dataset."
      exit
    fi
else
    echo "Adult is already downloaded"
fi

echo "Done"

echo ""
echo ""

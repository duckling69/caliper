#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Set ARCH
ARCH=`uname -m`

# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Switch into the integration tests directory to access required npm run commands
cd "${DIR}"

# Verdaccio server requires a dummy user if publishing via npm
echo '//localhost:4873/:_authToken="foo"' > ${HOME}/.npmrc
echo fetch-retries=10 >> ${HOME}/.npmrc
export npm_config_registry=http://localhost:4873

# Start npm server
PM2_HOME=.pm2 pm2 start verdaccio -- -l 0.0.0.0:4873 -c scripts/config.yaml
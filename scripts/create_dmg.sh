

function transform() {
    local changelog=`cat $1`
    changelog=${changelog%%---*}
    changelog=${changelog#*###}
    changelog="###$changelog"
    echo "$changelog<?"
}


function sparkle_enclosure() {
    local signature=`$PWD/assets/sign_update -s $SPARKLE_KEY $APP_NAME.dmg`
    local enclosure="<enclosure 
    url=\"$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/releases/download/$APP_VERSION/$APP_NAME.dmg\" 
    sparkle:version=\"$APP_VERSION\" 
    $signature
    type=\"application/octet-stream\" />"
    echo $enclosure
}

function generate_changlog() {
    echo "$(transform changelogs/CHANGELOG.md)" > $BODY_PATH
    echo "$(transform changelogs/CHANGELOG_SC.md)" >> $BODY_PATH
    echo $(sparkle_enclosure) >> $BODY_PATH
}


function create_dmg() {
    npm install --global create-dmg
    create-dmg $APP_NAME.app
    mv $APP_NAME*.dmg $APP_NAME.dmg
}

function test() {

    echo "$(transform CHANGELOG.md)" > TEST.md
    echo "$(transform CHANGELOG_SC.md)" >> TEST.md

}
# test
create_dmg
generate_changlog



changelog="changelogs/CHANGELOG.md"
changelogSC="changelogs/CHANGELOG_SC.md"

function __transform() {
    local changelog=`cat $1`
    changelog=${changelog%%---*}
    changelog=${changelog#*###}
    changelog="###$changelog"
    echo "$changelog<!--"
}

function __sparkle_enclosure() {
    local github=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY
    local signature=`echo $SPARKLE_KEY | ./bin/sign_update -f - $DMG_PATH`
    local enclosure="<sparkle:version>$APP_BUILD</sparkle:version>
    <sparkle:shortVersionString>$APP_VERSION</sparkle:shortVersionString>
    <sparkle:minimumSystemVersion>$SYS_MIN_VERSION</sparkle:minimumSystemVersion>
    <sparkle:fullReleaseNotesLink xml:lang=\"en\">$github/blob/master/$changelog</sparkle:fullReleaseNotesLink>
    <sparkle:fullReleaseNotesLink xml:lang=\"zh\">$github/blob/master/$changelogSC</sparkle:fullReleaseNotesLink>
    <enclosure url=\"$github/releases/download/$APP_TAG_NAME/$APP_NAME.dmg\" $signature type=\"applicationoctet-stream\" />"
    echo $enclosure
}

function create_dmg() {
    cd $BUILD_PATH
    if [ -f "$APP_NAME.app.dSYM.zip" ]; then
    rm $APP_NAME.dmg
    npm install --global create-dmg
    brew install graphicsmagick imagemagick
    create-dmg $APP_NAME.app --dmg-title="$APP_NAME $APP_TAG_NAME" --identity='Mac Developer'
    mv $APP_NAME*.dmg $APP_NAME.dmg
    else
    UI.user_error!("💥 $APP_NAME.app does not exist.")
    fi
    cd ..
}

function generate_changlog() {
    echo "$(__transform $changelog)" > $LOG_PATH
    echo "$(__transform $changelogSC)" >> $LOG_PATH
    echo $(__sparkle_enclosure) >> $LOG_PATH
}

create_dmg
generate_changlog
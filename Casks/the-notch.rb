cask "the-notch" do
  version "1.0.0-beta.4"
  sha256 "301fcbc925db9f90f388d00b9995a2965dae9ebff2fdc54fce11331ff30db30b"

  url "https://github.com/Vallykrie/The-Notch/releases/download/v#{version}/The-Notch-#{version}.dmg"
  name "The Notch"
  desc "Notch shell with a control surface for AI coding agents"
  homepage "https://github.com/Vallykrie/The-Notch"

  livecheck do
    url :url
    # The default GithubReleases strategy drops prereleases and its regex stops at the
    # numeric part, so every -beta tag reads as "no version found". Match the full tag
    # and keep prereleases; only drafts are skipped.
    regex(/^v?(\d+(?:\.\d+)*(?:-[0-9a-z.]+)?)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: :sonoma

  app "The Notch.app"

  uninstall quit: "com.nathansudiara.The-Notch"

  zap trash: [
    "~/.the-notch",
    "~/Library/Caches/com.nathansudiara.The-Notch",
    "~/Library/HTTPStorages/com.nathansudiara.The-Notch",
    "~/Library/Preferences/com.nathansudiara.The-Notch.plist",
    "~/Library/Saved Application State/com.nathansudiara.The-Notch.savedState",
  ]

  caveats do
    <<~EOS
      This build is not yet notarised, so macOS will refuse the first launch.
      Clear the quarantine flag once, then open it normally:

        xattr -dr com.apple.quarantine "/Applications/The Notch.app"

      (Right-click the app and choose Open works too. Homebrew 6 has no
      --no-quarantine flag; it always quarantines a cask.)

      The Notch has no Dock icon — it lives in the notch. Launch it from Spotlight
      or Launchpad the first time.

      It needs Accessibility permission to jump back to the terminal window that an
      agent is waiting in. macOS will prompt on first use.

      Uninstalling leaves The Notch's hook entries in ~/.claude/settings.json and
      ~/.codex/hooks.json. They fail open, so your agents keep working, but you can
      remove them by hand.
    EOS
  end
end

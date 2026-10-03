cask "the-notch" do
  version "1.0.0-beta.9"
  sha256 "773a72475f3d8937950720a7215197792b4f3bc48f115d947327d8346b40949e"

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
      The Notch has no Dock icon — it lives in the notch. Launch it from Spotlight
      or Launchpad the first time.

      macOS asks for two permissions, both optional:
      - Accessibility, to replace the system volume and brightness indicators.
      - Automation, the first time The Notch talks to another app: to show what
        Spotify or Music is playing, and to jump back to the Terminal or iTerm
        tab an agent is waiting in.

      Uninstalling leaves The Notch's hook entries in ~/.claude/settings.json and
      ~/.codex/hooks.json. They fail open, so your agents keep working, but you can
      remove them by hand.
    EOS
  end
end

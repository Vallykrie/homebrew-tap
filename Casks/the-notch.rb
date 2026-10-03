cask "the-notch" do
  version "1.0.0-beta.7"
  sha256 "f0755483ee2400a2bc1b0e76aa315768b5f6f8c3252c0002272632f492a43e91"

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

      It needs Accessibility permission to jump back to the terminal window that an
      agent is waiting in. macOS will prompt on first use.

      Uninstalling leaves The Notch's hook entries in ~/.claude/settings.json and
      ~/.codex/hooks.json. They fail open, so your agents keep working, but you can
      remove them by hand.
    EOS
  end
end

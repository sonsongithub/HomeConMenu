@objc public enum MusicEKnd : AEKeyword {
    case trackListing = 0x6b54726b
    case albumListing = 0x6b416c62
    case cdInsert = 0x6b434469
};
@objc public enum MusicEnum : AEKeyword {
    case standard = 0x6c777374
    case detailed = 0x6c776474
};
@objc public enum MusicEPlS : AEKeyword {
    case stopped = 0x6b505353
    case playing = 0x6b505350
    case paused = 0x6b505370
    case fastForwarding = 0x6b505346
    case rewinding = 0x6b505352
};
@objc public enum MusicERpt : AEKeyword {
    case off = 0x6b52704f
    case one = 0x6b527031
    case all = 0x6b416c6c
};
@objc public enum MusicEShM : AEKeyword {
    case songs = 0x6b536853
    case albums = 0x6b536841
    case groupings = 0x6b536847
};
@objc public enum MusicESrc : AEKeyword {
    case library = 0x6b4c6962
    case audioCD = 0x6b414344
    case mP3CD = 0x6b4d4344
    case radioTuner = 0x6b54756e
    case sharedLibrary = 0x6b536864
    case iTunesStore = 0x6b495453
    case unknown = 0x6b556e6b
};
@objc public enum MusicESrA : AEKeyword {
    case albums = 0x6b53724c
    case all = 0x6b416c6c
    case artists = 0x6b537252
    case composers = 0x6b537243
    case displayed = 0x6b537256
    case names = 0x6b537253
};
@objc public enum MusicESpK : AEKeyword {
    case none = 0x6b4e6f6e
    case folder = 0x6b537046
    case genius = 0x6b537047
    case library = 0x6b53704c
    case music = 0x6b53705a
    case purchasedMusic = 0x6b53704d
};
@objc public enum MusicEMdK : AEKeyword {
    case song = 0x6b4d6453
    case musicVideo = 0x6b566456
    case movie = 0x6b56644d
    case tVShow = 0x6b566454
    case unknown = 0x6b556e6b
};
@objc public enum MusicERtK : AEKeyword {
    case user = 0x6b527455
    case computed = 0x6b527443
};
@objc public enum MusicEAPD : AEKeyword {
    case computer = 0x6b415043
    case airPortExpress = 0x6b415058
    case appleTV = 0x6b415054
    case airPlayDevice = 0x6b41504f
    case bluetoothDevice = 0x6b415042
    case homePod = 0x6b415048
    case tV = 0x6b415056
    case unknown = 0x6b415055
};
@objc public enum MusicEClS : AEKeyword {
    case unknown = 0x6b556e6b
    case purchased = 0x6b507572
    case matched = 0x6b4d6174
    case uploaded = 0x6b55706c
    case ineligible = 0x6b52656a
    case removed = 0x6b52656d
    case error = 0x6b457272
    case duplicate = 0x6b447570
    case subscription = 0x6b537562
    case prerelease = 0x6b507252
    case noLongerAvailable = 0x6b526576
    case notUploaded = 0x6b557050
};
@objc public enum MusicEExF : AEKeyword {
    case plainText = 0x6b545854
    case unicodeText = 0x6b554354
    case xML = 0x6b584d4c
    case m3U = 0x6b4d3355
    case m3U8 = 0x6b4d3338
};
@objc public protocol MusicGenericMethods {
    @objc optional func printPrintDialog(printDialog: Bool, withProperties: NSDictionary, kind: MusicEKnd, theme: NSString);
    @objc optional func close();
    @objc optional func delete();
    @objc optional func duplicateTo(to: SBObject) -> SBObject;
    @objc optional func exists() -> Bool;
    @objc optional func open();
    @objc optional func save();
    @objc optional func playOnce(once: Bool);
    @objc optional func select();
}
extension SBObject: MusicGenericMethods {}
@objc public protocol MusicApplication {
    @objc optional var AirPlayEnabled: Bool { get }
    @objc optional var converting: Bool { get }
    @objc optional var currentAirPlayDevices: [MusicAirPlayDevice] { get }
    @objc optional func setCurrentAirPlayDevices(_ currentAirPlayDevices: [MusicAirPlayDevice])
    @objc optional var currentEncoder: MusicEncoder { get }
    @objc optional func setCurrentEncoder(_ currentEncoder: MusicEncoder)
    @objc optional var currentEQPreset: MusicEQPreset { get }
    @objc optional func setCurrentEQPreset(_ currentEQPreset: MusicEQPreset)
    @objc optional var currentPlaylist: MusicPlaylist { get }
    @objc optional var currentStreamTitle: NSString { get }
    @objc optional var currentStreamURL: NSString { get }
    @objc optional var currentTrack: MusicTrack { get }
    @objc optional var currentVisual: MusicVisual { get }
    @objc optional func setCurrentVisual(_ currentVisual: MusicVisual)
    @objc optional var EQEnabled: Bool { get }
    @objc optional func setEQEnabled(_ EQEnabled: Bool)
    @objc optional var fixedIndexing: Bool { get }
    @objc optional func setFixedIndexing(_ fixedIndexing: Bool)
    @objc optional var frontmost: Bool { get }
    @objc optional func setFrontmost(_ frontmost: Bool)
    @objc optional var fullScreen: Bool { get }
    @objc optional func setFullScreen(_ fullScreen: Bool)
    @objc optional var name: NSString { get }
    @objc optional var mute: Bool { get }
    @objc optional func setMute(_ mute: Bool)
    @objc optional var playerPosition: Double { get }
    @objc optional func setPlayerPosition(_ playerPosition: Double)
    @objc optional var playerState: MusicEPlS { get }
    @objc optional var selection: SBObject { get }
    @objc optional var shuffleEnabled: Bool { get }
    @objc optional func setShuffleEnabled(_ shuffleEnabled: Bool)
    @objc optional var shuffleMode: MusicEShM { get }
    @objc optional func setShuffleMode(_ shuffleMode: MusicEShM)
    @objc optional var songRepeat: MusicERpt { get }
    @objc optional func setSongRepeat(_ songRepeat: MusicERpt)
    @objc optional var soundVolume: NSInteger { get }
    @objc optional func setSoundVolume(_ soundVolume: NSInteger)
    @objc optional var version: NSString { get }
    @objc optional var visualsEnabled: Bool { get }
    @objc optional func setVisualsEnabled(_ visualsEnabled: Bool)
    @objc optional func AirPlayDevices() -> [MusicAirPlayDevice];
    @objc optional func browserWindows() -> [MusicBrowserWindow];
    @objc optional func encoders() -> [MusicEncoder];
    @objc optional func EQPresets() -> [MusicEQPreset];
    @objc optional func EQWindows() -> [MusicEQWindow];
    @objc optional func miniplayerWindows() -> [MusicMiniplayerWindow];
    @objc optional func playlists() -> [MusicPlaylist];
    @objc optional func playlistWindows() -> [MusicPlaylistWindow];
    @objc optional func sources() -> [MusicSource];
    @objc optional func tracks() -> [MusicTrack];
    @objc optional func videoWindows() -> [MusicVideoWindow];
    @objc optional func visuals() -> [MusicVisual];
    @objc optional func windows() -> [MusicWindow];
    @objc optional func printPrintDialog(printDialog: Bool, withProperties: NSDictionary, kind: MusicEKnd, theme: NSString);
    @objc optional func run();
    @objc optional func quit();
    @objc optional func add(x: [NSURL], to: SBObject) -> MusicTrack;
    @objc optional func backTrack();
    @objc optional func convert(x: [SBObject]) -> MusicTrack;
    @objc optional func fastForward();
    @objc optional func nextTrack();
    @objc optional func pause();
    @objc optional func playOnce(once: Bool);
    @objc optional func playpause();
    @objc optional func previousTrack();
    @objc optional func resume();
    @objc optional func rewind();
    @objc optional func stop();
    @objc optional func openLocation(x: NSString);
}
extension SBObject: MusicApplication {}
@objc public protocol MusicItem : MusicGenericMethods {
    @objc optional var container: SBObject { get }
    @objc optional var index: NSInteger { get }
    @objc optional var name: NSString { get }
    @objc optional func setName(_ name: NSString)
    @objc optional var persistentID: NSString { get }
    @objc optional var properties: NSDictionary { get }
    @objc optional func setProperties(_ properties: NSDictionary)
    @objc optional func id() -> NSInteger;
    @objc optional func download();
    @objc optional func exportAs(as: MusicEExF, to: NSURL) -> NSString;
    @objc optional func reveal();
}
extension SBObject: MusicItem {}
@objc public protocol MusicAirPlayDevice : MusicItem {
    @objc optional var active: Bool { get }
    @objc optional var available: Bool { get }
    @objc optional var kind: MusicEAPD { get }
    @objc optional var networkAddress: NSString { get }
    @objc optional var selected: Bool { get }
    @objc optional func setSelected(_ selected: Bool)
    @objc optional var supportsAudio: Bool { get }
    @objc optional var supportsVideo: Bool { get }
    @objc optional var soundVolume: NSInteger { get }
    @objc optional func setSoundVolume(_ soundVolume: NSInteger)
    @objc optional func protected() -> Bool;
}
extension SBObject: MusicAirPlayDevice {}
@objc public protocol MusicArtwork : MusicItem {
    @objc optional var data: NSImage { get }
    @objc optional func setData(_ data: NSImage)
    @objc optional var objectDescription: NSString { get }
    @objc optional func setObjectDescription(_ objectDescription: NSString)
    @objc optional var downloaded: Bool { get }
    @objc optional var format: NSNumber { get }
    @objc optional var kind: NSInteger { get }
    @objc optional func setKind(_ kind: NSInteger)
    @objc optional var rawData: Any { get }
    @objc optional func setRawData(_ rawData: Any)
}
extension SBObject: MusicArtwork {}
@objc public protocol MusicEncoder : MusicItem {
    @objc optional var format: NSString { get }
}
extension SBObject: MusicEncoder {}
@objc public protocol MusicEQPreset : MusicItem {
    @objc optional var band1: Double { get }
    @objc optional func setBand1(_ band1: Double)
    @objc optional var band2: Double { get }
    @objc optional func setBand2(_ band2: Double)
    @objc optional var band3: Double { get }
    @objc optional func setBand3(_ band3: Double)
    @objc optional var band4: Double { get }
    @objc optional func setBand4(_ band4: Double)
    @objc optional var band5: Double { get }
    @objc optional func setBand5(_ band5: Double)
    @objc optional var band6: Double { get }
    @objc optional func setBand6(_ band6: Double)
    @objc optional var band7: Double { get }
    @objc optional func setBand7(_ band7: Double)
    @objc optional var band8: Double { get }
    @objc optional func setBand8(_ band8: Double)
    @objc optional var band9: Double { get }
    @objc optional func setBand9(_ band9: Double)
    @objc optional var band10: Double { get }
    @objc optional func setBand10(_ band10: Double)
    @objc optional var modifiable: Bool { get }
    @objc optional var preamp: Double { get }
    @objc optional func setPreamp(_ preamp: Double)
    @objc optional var updateTracks: Bool { get }
    @objc optional func setUpdateTracks(_ updateTracks: Bool)
}
extension SBObject: MusicEQPreset {}
@objc public protocol MusicPlaylist : MusicItem {
    @objc optional var objectDescription: NSString { get }
    @objc optional func setObjectDescription(_ objectDescription: NSString)
    @objc optional var disliked: Bool { get }
    @objc optional func setDisliked(_ disliked: Bool)
    @objc optional var duration: NSInteger { get }
    @objc optional var name: NSString { get }
    @objc optional func setName(_ name: NSString)
    @objc optional var favorited: Bool { get }
    @objc optional func setFavorited(_ favorited: Bool)
    @objc optional var parent: MusicPlaylist { get }
    @objc optional var size: NSInteger { get }
    @objc optional var specialKind: MusicESpK { get }
    @objc optional var time: NSString { get }
    @objc optional var visible: Bool { get }
    @objc optional func tracks() -> [MusicTrack];
    @objc optional func artworks() -> [MusicArtwork];
    @objc optional func moveTo(to: SBObject);
    @objc optional func searchFor(for_: NSString, only: MusicESrA) -> MusicTrack;
}
extension SBObject: MusicPlaylist {}
@objc public protocol MusicAudioCDPlaylist : MusicPlaylist {
    @objc optional var artist: NSString { get }
    @objc optional func setArtist(_ artist: NSString)
    @objc optional var compilation: Bool { get }
    @objc optional func setCompilation(_ compilation: Bool)
    @objc optional var composer: NSString { get }
    @objc optional func setComposer(_ composer: NSString)
    @objc optional var discCount: NSInteger { get }
    @objc optional func setDiscCount(_ discCount: NSInteger)
    @objc optional var discNumber: NSInteger { get }
    @objc optional func setDiscNumber(_ discNumber: NSInteger)
    @objc optional var genre: NSString { get }
    @objc optional func setGenre(_ genre: NSString)
    @objc optional var year: NSInteger { get }
    @objc optional func setYear(_ year: NSInteger)
    @objc optional func audioCDTracks() -> [MusicAudioCDTrack];
}
extension SBObject: MusicAudioCDPlaylist {}
@objc public protocol MusicLibraryPlaylist : MusicPlaylist {
    @objc optional func fileTracks() -> [MusicFileTrack];
    @objc optional func URLTracks() -> [MusicURLTrack];
    @objc optional func sharedTracks() -> [MusicSharedTrack];
}
extension SBObject: MusicLibraryPlaylist {}
@objc public protocol MusicRadioTunerPlaylist : MusicPlaylist {
    @objc optional func URLTracks() -> [MusicURLTrack];
}
extension SBObject: MusicRadioTunerPlaylist {}
@objc public protocol MusicSource : MusicItem {
    @objc optional var capacity: Int64 { get }
    @objc optional var freeSpace: Int64 { get }
    @objc optional var kind: MusicESrc { get }
    @objc optional func audioCDPlaylists() -> [MusicAudioCDPlaylist];
    @objc optional func libraryPlaylists() -> [MusicLibraryPlaylist];
    @objc optional func playlists() -> [MusicPlaylist];
    @objc optional func radioTunerPlaylists() -> [MusicRadioTunerPlaylist];
    @objc optional func subscriptionPlaylists() -> [MusicSubscriptionPlaylist];
    @objc optional func userPlaylists() -> [MusicUserPlaylist];
}
extension SBObject: MusicSource {}
@objc public protocol MusicSubscriptionPlaylist : MusicPlaylist {
    @objc optional func fileTracks() -> [MusicFileTrack];
    @objc optional func URLTracks() -> [MusicURLTrack];
}
extension SBObject: MusicSubscriptionPlaylist {}
@objc public protocol MusicTrack : MusicItem {
    @objc optional var album: NSString { get }
    @objc optional func setAlbum(_ album: NSString)
    @objc optional var albumArtist: NSString { get }
    @objc optional func setAlbumArtist(_ albumArtist: NSString)
    @objc optional var albumDisliked: Bool { get }
    @objc optional func setAlbumDisliked(_ albumDisliked: Bool)
    @objc optional var albumFavorited: Bool { get }
    @objc optional func setAlbumFavorited(_ albumFavorited: Bool)
    @objc optional var albumRating: NSInteger { get }
    @objc optional func setAlbumRating(_ albumRating: NSInteger)
    @objc optional var albumRatingKind: MusicERtK { get }
    @objc optional var artist: NSString { get }
    @objc optional func setArtist(_ artist: NSString)
    @objc optional var bitRate: NSInteger { get }
    @objc optional var bookmark: Double { get }
    @objc optional func setBookmark(_ bookmark: Double)
    @objc optional var bookmarkable: Bool { get }
    @objc optional func setBookmarkable(_ bookmarkable: Bool)
    @objc optional var bpm: NSInteger { get }
    @objc optional func setBpm(_ bpm: NSInteger)
    @objc optional var category: NSString { get }
    @objc optional func setCategory(_ category: NSString)
    @objc optional var cloudStatus: MusicEClS { get }
    @objc optional var comment: NSString { get }
    @objc optional func setComment(_ comment: NSString)
    @objc optional var compilation: Bool { get }
    @objc optional func setCompilation(_ compilation: Bool)
    @objc optional var composer: NSString { get }
    @objc optional func setComposer(_ composer: NSString)
    @objc optional var databaseID: NSInteger { get }
    @objc optional var dateAdded: NSDate { get }
    @objc optional var objectDescription: NSString { get }
    @objc optional func setObjectDescription(_ objectDescription: NSString)
    @objc optional var discCount: NSInteger { get }
    @objc optional func setDiscCount(_ discCount: NSInteger)
    @objc optional var discNumber: NSInteger { get }
    @objc optional func setDiscNumber(_ discNumber: NSInteger)
    @objc optional var disliked: Bool { get }
    @objc optional func setDisliked(_ disliked: Bool)
    @objc optional var downloaderAccount: NSString { get }
    @objc optional var downloaderName: NSString { get }
    @objc optional var duration: Double { get }
    @objc optional var enabled: Bool { get }
    @objc optional func setEnabled(_ enabled: Bool)
    @objc optional var episodeID: NSString { get }
    @objc optional func setEpisodeID(_ episodeID: NSString)
    @objc optional var episodeNumber: NSInteger { get }
    @objc optional func setEpisodeNumber(_ episodeNumber: NSInteger)
    @objc optional var EQ: NSString { get }
    @objc optional func setEQ(_ EQ: NSString)
    @objc optional var finish: Double { get }
    @objc optional func setFinish(_ finish: Double)
    @objc optional var gapless: Bool { get }
    @objc optional func setGapless(_ gapless: Bool)
    @objc optional var genre: NSString { get }
    @objc optional func setGenre(_ genre: NSString)
    @objc optional var grouping: NSString { get }
    @objc optional func setGrouping(_ grouping: NSString)
    @objc optional var kind: NSString { get }
    @objc optional var longDescription: NSString { get }
    @objc optional func setLongDescription(_ longDescription: NSString)
    @objc optional var favorited: Bool { get }
    @objc optional func setFavorited(_ favorited: Bool)
    @objc optional var lyrics: NSString { get }
    @objc optional func setLyrics(_ lyrics: NSString)
    @objc optional var mediaKind: MusicEMdK { get }
    @objc optional func setMediaKind(_ mediaKind: MusicEMdK)
    @objc optional var modificationDate: NSDate { get }
    @objc optional var movement: NSString { get }
    @objc optional func setMovement(_ movement: NSString)
    @objc optional var movementCount: NSInteger { get }
    @objc optional func setMovementCount(_ movementCount: NSInteger)
    @objc optional var movementNumber: NSInteger { get }
    @objc optional func setMovementNumber(_ movementNumber: NSInteger)
    @objc optional var playedCount: NSInteger { get }
    @objc optional func setPlayedCount(_ playedCount: NSInteger)
    @objc optional var playedDate: NSDate { get }
    @objc optional func setPlayedDate(_ playedDate: NSDate)
    @objc optional var purchaserAccount: NSString { get }
    @objc optional var purchaserName: NSString { get }
    @objc optional var rating: NSInteger { get }
    @objc optional func setRating(_ rating: NSInteger)
    @objc optional var ratingKind: MusicERtK { get }
    @objc optional var releaseDate: NSDate { get }
    @objc optional var sampleRate: NSInteger { get }
    @objc optional var seasonNumber: NSInteger { get }
    @objc optional func setSeasonNumber(_ seasonNumber: NSInteger)
    @objc optional var shufflable: Bool { get }
    @objc optional func setShufflable(_ shufflable: Bool)
    @objc optional var skippedCount: NSInteger { get }
    @objc optional func setSkippedCount(_ skippedCount: NSInteger)
    @objc optional var skippedDate: NSDate { get }
    @objc optional func setSkippedDate(_ skippedDate: NSDate)
    @objc optional var show: NSString { get }
    @objc optional func setShow(_ show: NSString)
    @objc optional var sortAlbum: NSString { get }
    @objc optional func setSortAlbum(_ sortAlbum: NSString)
    @objc optional var sortArtist: NSString { get }
    @objc optional func setSortArtist(_ sortArtist: NSString)
    @objc optional var sortAlbumArtist: NSString { get }
    @objc optional func setSortAlbumArtist(_ sortAlbumArtist: NSString)
    @objc optional var sortName: NSString { get }
    @objc optional func setSortName(_ sortName: NSString)
    @objc optional var sortComposer: NSString { get }
    @objc optional func setSortComposer(_ sortComposer: NSString)
    @objc optional var sortShow: NSString { get }
    @objc optional func setSortShow(_ sortShow: NSString)
    @objc optional var size: Int64 { get }
    @objc optional var start: Double { get }
    @objc optional func setStart(_ start: Double)
    @objc optional var time: NSString { get }
    @objc optional var trackCount: NSInteger { get }
    @objc optional func setTrackCount(_ trackCount: NSInteger)
    @objc optional var trackNumber: NSInteger { get }
    @objc optional func setTrackNumber(_ trackNumber: NSInteger)
    @objc optional var unplayed: Bool { get }
    @objc optional func setUnplayed(_ unplayed: Bool)
    @objc optional var volumeAdjustment: NSInteger { get }
    @objc optional func setVolumeAdjustment(_ volumeAdjustment: NSInteger)
    @objc optional var work: NSString { get }
    @objc optional func setWork(_ work: NSString)
    @objc optional var year: NSInteger { get }
    @objc optional func setYear(_ year: NSInteger)
    @objc optional func artworks() -> [MusicArtwork];
}
extension SBObject: MusicTrack {}
@objc public protocol MusicAudioCDTrack : MusicTrack {
    @objc optional var location: NSURL { get }
}
extension SBObject: MusicAudioCDTrack {}
@objc public protocol MusicFileTrack : MusicTrack {
    @objc optional var location: NSURL { get }
    @objc optional func setLocation(_ location: NSURL)
    @objc optional func refresh();
}
extension SBObject: MusicFileTrack {}
@objc public protocol MusicSharedTrack : MusicTrack {
}
extension SBObject: MusicSharedTrack {}
@objc public protocol MusicURLTrack : MusicTrack {
    @objc optional var address: NSString { get }
    @objc optional func setAddress(_ address: NSString)
}
extension SBObject: MusicURLTrack {}
@objc public protocol MusicUserPlaylist : MusicPlaylist {
    @objc optional var shared: Bool { get }
    @objc optional func setShared(_ shared: Bool)
    @objc optional var smart: Bool { get }
    @objc optional var genius: Bool { get }
    @objc optional func fileTracks() -> [MusicFileTrack];
    @objc optional func URLTracks() -> [MusicURLTrack];
    @objc optional func sharedTracks() -> [MusicSharedTrack];
}
extension SBObject: MusicUserPlaylist {}
@objc public protocol MusicFolderPlaylist : MusicUserPlaylist {
}
extension SBObject: MusicFolderPlaylist {}
@objc public protocol MusicVisual : MusicItem {
}
extension SBObject: MusicVisual {}
@objc public protocol MusicWindow : MusicItem {
    @objc optional var bounds: NSRect { get }
    @objc optional func setBounds(_ bounds: NSRect)
    @objc optional var closeable: Bool { get }
    @objc optional var collapseable: Bool { get }
    @objc optional var collapsed: Bool { get }
    @objc optional func setCollapsed(_ collapsed: Bool)
    @objc optional var fullScreen: Bool { get }
    @objc optional func setFullScreen(_ fullScreen: Bool)
    @objc optional var position: NSPoint { get }
    @objc optional func setPosition(_ position: NSPoint)
    @objc optional var resizable: Bool { get }
    @objc optional var visible: Bool { get }
    @objc optional func setVisible(_ visible: Bool)
    @objc optional var zoomable: Bool { get }
    @objc optional var zoomed: Bool { get }
    @objc optional func setZoomed(_ zoomed: Bool)
}
extension SBObject: MusicWindow {}
@objc public protocol MusicBrowserWindow : MusicWindow {
    @objc optional var selection: SBObject { get }
    @objc optional var view: MusicPlaylist { get }
    @objc optional func setView(_ view: MusicPlaylist)
}
extension SBObject: MusicBrowserWindow {}
@objc public protocol MusicEQWindow : MusicWindow {
}
extension SBObject: MusicEQWindow {}
@objc public protocol MusicMiniplayerWindow : MusicWindow {
}
extension SBObject: MusicMiniplayerWindow {}
@objc public protocol MusicPlaylistWindow : MusicWindow {
    @objc optional var selection: SBObject { get }
    @objc optional var view: MusicPlaylist { get }
}
extension SBObject: MusicPlaylistWindow {}
@objc public protocol MusicVideoWindow : MusicWindow {
}
extension SBObject: MusicVideoWindow {}

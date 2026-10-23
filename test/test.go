package main

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/op/go-logging"

	lt "github.com/ElementumOrg/libtorrent-go"
)

var log = logging.MustGetLogger("test")

// StatusStrings ...
var StatusStrings = []string{
	"Queued",
	"Checking",
	"Finding",
	"Buffering",
	"Finished",
	"Seeding",
	"Allocating",
	"Stalled",
}

const (
	ipToSDefault     = iota
	ipToSLowDelay    = 1 << iota
	ipToSReliability = 1 << iota
	ipToSThroughput  = 1 << iota
	ipToSLowCost     = 1 << iota
)

func main() {
	fmt.Printf("Testing libtorrent package: %s \n", lt.Version())

	dir, err := os.Getwd()
	if err != nil {
		panic("Can't get current directory")
	}

	settings := lt.NewSettingsPack()
	defer lt.DeleteSettingsPack(settings)

	session, err := lt.NewSession(settings, int(lt.WrappedSessionHandleAddDefaultPlugins))
	if err != nil {
		panic(fmt.Sprintf("Can't create session: %v", err))
	}
	defer lt.DeleteSession(session)

	sessionHandle, err := session.GetHandle()
	if err != nil {
		panic(fmt.Sprintf("Can't get session handle: %v", err))
	}

	settings.SetInt("request_timeout", 2)
	settings.SetInt("peer_connect_timeout", 2)
	settings.SetBool("strict_end_game_mode", true)
	settings.SetBool("announce_to_all_trackers", true)
	settings.SetBool("announce_to_all_tiers", true)
	settings.SetInt("connection_speed", 500)
	settings.SetInt("download_rate_limit", 0)
	settings.SetInt("upload_rate_limit", 0)
	settings.SetInt("choking_algorithm", 0)
	settings.SetInt("share_ratio_limit", 0)
	settings.SetInt("seed_time_ratio_limit", 0)
	settings.SetInt("seed_time_limit", 0)
	settings.SetInt("peer_tos", ipToSLowCost)
	settings.SetInt("torrent_connect_boost", 0)
	settings.SetBool("rate_limit_ip_overhead", true)
	settings.SetBool("no_atime_storage", true)
	settings.SetBool("announce_double_nat", true)
	settings.SetBool("prioritize_partial_pieces", false)
	settings.SetBool("free_torrent_hashes", true)
	settings.SetBool("use_parole_mode", true)
	settings.SetInt("seed_choking_algorithm", int(lt.SettingsPackFastestUpload))
	settings.SetBool("upnp_ignore_nonrouters", true)
	settings.SetBool("lazy_bitfields", true)
	settings.SetInt("stop_tracker_timeout", 1)
	settings.SetInt("auto_scrape_interval", 1200)
	settings.SetInt("auto_scrape_min_interval", 900)
	settings.SetBool("ignore_limits_on_local_network", true)
	settings.SetBool("rate_limit_utp", true)
	settings.SetInt("mixed_mode_algorithm", int(lt.SettingsPackPreferTcp))
	settings.SetInt("network_threads", 0)

	sessionHandle.ApplySettings(settings)

	torrentParams := lt.NewAddTorrentParams()
	defer lt.DeleteAddTorrentParams(torrentParams)

	torrentFile := filepath.Join(dir, "test2.torrent")
	log.Infof("Loading torrent file: %s", torrentFile)

	info := lt.NewTorrentInfo(torrentFile)
	defer lt.DeleteTorrentInfo(info)

	torrentParams.SetMemoryStorage(50 * 1024 * 1024)
	torrentParams.SetTorrentInfo(info)
	torrentParams.SetSavePath(dir)

	torrentHandle, err := sessionHandle.AddTorrent(torrentParams)
	if err != nil {
		log.Errorf("Error adding torrent file for %s: %v", torrentFile, err)
		return
	}
	defer lt.DeleteWrappedTorrentHandle(torrentHandle)

	// numFiles := info.NumFiles()
	// filesPriorities := libtorrent.NewStdVectorInt()
	// defer libtorrent.DeleteStdVectorInt(filesPriorities)

	// for i := 0; i < numFiles; i++ {
	// 	filesPriorities.Add(4)
	// }
	// torrentHandle.PrioritizeFiles(filesPriorities)

	// torrentStatus := torrentHandle.Status(uint(libtorrent.TorrentHandleQueryName))
	// torrentName := torrentStatus.GetName()
	// progress := int(float64(torrentStatus.GetProgress()) * 100)
	// log.Infof("Status start: %v - %v", torrentName, progress)

	// time.Sleep(10 * time.Second)
	// log.Infof("Status now1: %#v, %v - %v", torrentHandle, torrentName, progress)
	// torrentStatus2 := torrentHandle.Status(uint(libtorrent.TorrentHandleQueryName))
	// log.Infof("Status now: %v - %v", torrentName, progress)
	// torrentName = torrentStatus2.GetName()
	// log.Infof("Status now: %v - %v", torrentName, progress)
	// progress = int(float64(torrentStatus2.GetProgress()) * 100)
	// log.Infof("Status now: %v - %v", torrentName, progress)

	num := 0
	rotateTicker := time.NewTicker(2 * time.Second)
	defer rotateTicker.Stop()

	for {
		select {
		case <-rotateTicker.C:

			log.Infof("Getting session")
			log.Infof("Session: %#v", sessionHandle)
			torrentsVector := sessionHandle.GetTorrents()
			// defer libtorrent.DeleteStdVectorTorrentHandle(torrentsVector)
			torrentsVectorSize := int(torrentsVector.Size())

			log.Infof("Got %d torrents", torrentsVectorSize)
			for i := 0; i < torrentsVectorSize; i++ {
				torrentHandle := torrentsVector.Get(i)
				if torrentHandle.IsValid() == false {
					continue
				}

				torrentStatus := torrentHandle.Status(uint(lt.WrappedTorrentHandleQueryName))
				status := StatusStrings[int(torrentStatus.GetState())]

				torrentName := torrentStatus.GetName()
				progress := int(float64(torrentStatus.GetProgress()) * 100)

				log.Infof("Torrent status. Name: %s, Status: %s, Progress: %v", torrentName, status, progress)
			}

			num++
			if num > 8 {
				rotateTicker.Stop()
				os.Exit(0)
			}
		}
	}

	// storage := libtorrent.NewMemoryStorage()

}

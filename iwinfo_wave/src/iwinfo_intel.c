/*
 * iwinfo - Wireless Information Library - Madwifi Backend
 *
 *   Copyright (C) 2009-2010 Jo-Philipp Wich <xm@subsignal.org>
 *
 * The iwinfo library is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License version 2
 * as published by the Free Software Foundation.
 *
 * The iwinfo library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with the iwinfo library. If not, see http://www.gnu.org/licenses/.
 */

#include "iwinfo.h"
#include "iwinfo_wext.h"
#include "iwinfo_nl80211.h"
#include "api/intel.h"
#include "iwinfo_nl80211.h"


/* hack for now; should use pdb */
static const char * front_panel_to_phy(const char *ifname)
{
	if ( strcmp(ifname, "wifi2g") == 0 ) 
	{
		return( "wlan0" );
	} 
	else if ( strcmp(ifname, "wifi5g") == 0 ) 
	{
		return( "wlan2" );
	}
	
	return( "UNKNOWN" );
}

static char * hostapd_info(const char *ifname)
{
	char device[16] = { 0 };
	char path[1024] = { 0 };
	static char buf[16384] = { 0 };
	FILE *conf;

	if (strstr(ifname, "wifi") != NULL)
	{
		strncpy(device, front_panel_to_phy(ifname), 15 );
	}
	else
	{
		strncpy(device, ifname, 15 );
	}

	snprintf(path, sizeof(path), "/tmp/hostapd_%s.conf", device);

	if ((conf = fopen(path, "r")) != NULL)
	{
		fread(buf, sizeof(buf) - 1, 1, conf);
		fclose(conf);

		return buf;
	}

	return NULL;
}

static char * getval_from_hostapd_conf(const char *ifname, const char *buf, const char *key)
{
	int i, len;
	char lkey[64] = { 0 };
	const char *ln = buf;
	static char lval[256] = { 0 };
	int matched_if = ifname ? 0 : 1;

	for( i = 0, len = strlen(buf); i < len; i++ )
	{
		if (!lkey[0] && (buf[i] == ' ' || buf[i] == '\t'))
		{
				ln++;
		}
		else if (!lkey[0] && (buf[i] == '='))
		{
				if ((&buf[i] - ln) > 0)
					memcpy(lkey, ln, MIN(sizeof(lkey) - 1, &buf[i] - ln));
		}
		else if (buf[i] == '\n')
		{
			if (lkey[0])
			{
				memcpy(lval, ln + strlen(lkey) + 1,
					MIN(sizeof(lval) - 1, &buf[i] - ln - strlen(lkey) - 1));

				if ((ifname != NULL) &&
					(!strcmp(lkey, "interface") || !strcmp(lkey, "bss")) )
				{
					matched_if = !strcmp(lval, ifname);
				}
				else if (matched_if && !strcmp(lkey, key))
				{
					return lval;
				}
			}

			ln = &buf[i+1];
			memset(lkey, 0, sizeof(lkey));
			memset(lval, 0, sizeof(lval));
		}
	}

	return NULL;
}

int get_encryption(const char *ifname, struct iwinfo_crypto_entry *c)
{
	char *host_conf;
	char *param;
	//char command[MAX_LEN_RES_VALUE];

	host_conf = hostapd_info(ifname);
	if (!host_conf){
		//sprintf(command, "echo 'failed to read hostapd conf file for ifname: %s' > /dev/console", ifname);
		//system(command);
		return FAIL;
	}

	// for wep we use the hostapd conf file
	param = getval_from_hostapd_conf(ifname, host_conf, "wep_key0");
	if(param)
	{ /* check if this is wep */
		c->enabled = 1;
		c->auth_suites = IWINFO_KMGMT_NONE;
		c->auth_algs = IWINFO_AUTH_OPEN;
		c->wpa_version = 0;
		c->pair_ciphers = 0;
		c->group_ciphers = 0;

		return SUCCESS;
	}

	param = getval_from_hostapd_conf(ifname, host_conf, "wpa");
	if(param) {
		c->wpa_version = param[0] - '0';
	}

	param = getval_from_hostapd_conf(ifname, host_conf, "wpa_key_mgmt");
	if(param) {
		if (strncmp(param, "WPA-EAP", 6) == 0){
			c->auth_suites |= IWINFO_KMGMT_8021x;
		} else {
			c->auth_suites |= IWINFO_KMGMT_PSK;
		}
		c->enabled = 1;
	}

	param = getval_from_hostapd_conf(ifname, host_conf, "auth_algs");
	if(param) {
		c->auth_algs=param[0] - '0';
	}

	param = getval_from_hostapd_conf(ifname, host_conf, "wpa_pairwise");
	if(param) {
		if (strncmp(param, "TKIP", 5) == 0) {
			c->pair_ciphers |= IWINFO_CIPHER_TKIP;
			c->group_ciphers |= IWINFO_CIPHER_TKIP;
		} else if (strncmp(param, "CCMP", 5) == 0) {
			c->pair_ciphers |= IWINFO_CIPHER_CCMP;
			c->group_ciphers |= IWINFO_CIPHER_CCMP;
		} else {
			c->pair_ciphers |= IWINFO_CIPHER_CCMP | IWINFO_CIPHER_TKIP;
			c->group_ciphers |= IWINFO_CIPHER_CCMP | IWINFO_CIPHER_TKIP;
		}
	}

	return SUCCESS;
}

static int intel_probe(const char *ifname)
{
	if (strstr(ifname, "wifi") != NULL)
		return TRUE;
	else if (strstr(ifname, "wlan") != NULL)
		return TRUE;

	return FALSE;
}

static int intel_get_txpower(const char *ifname, int *buf)
{
	return nl80211_ops.txpower(ifname, buf);
}

static int intel_get_bitrate(const char *ifname, int *buf)
{
	return nl80211_ops.bitrate(ifname, buf);
}

static int intel_get_signal(const char *ifname, int *buf)
{
	return nl80211_ops.signal(ifname, buf);
}

static int intel_get_country(const char *ifname, char *buf)
{
	return nl80211_ops.country(ifname, buf);
}

static int intel_get_encryption(const char *ifname, char *buf)
{
	return get_encryption(ifname, (struct iwinfo_crypto_entry *)buf);
}

static int intel_get_assoclist(const char *ifname, char *buf, int *len)
{
	return nl80211_ops.assoclist(ifname, buf, len);
}

static int intel_get_freqlist(const char *ifname, char *buf, int *len)
{
	return nl80211_ops.freqlist(ifname, buf, len);
}

static int intel_get_mode(const char *ifname, int *buf)
{
	return nl80211_ops.mode(ifname, buf);
}

static int intel_get_hwmodelist(const char *ifname, int *buf)
{
	int ret = nl80211_ops.hwmodelist(ifname, buf);

	if ( ret == 0 )
	{
		if ( *buf & IWINFO_80211_B )
		{
			*buf &= ~(IWINFO_80211_AC);
		}
	}

	return ret;
}

static int intel_get_htmodelist(const char *ifname, int *buf)
{
	//return wext_ops.htmodelist(ifname, buf);


	if ( strcmp(ifname, "wifi2g") == 0 )
	{
		*buf |= IWINFO_HTMODE_HT20 | IWINFO_HTMODE_HT40;
	}
	else if ( strcmp(ifname, "wifi5g") == 0 )
	{
		*buf |= IWINFO_HTMODE_HT20 | IWINFO_HTMODE_HT40;
		*buf |= IWINFO_HTMODE_VHT20 | IWINFO_HTMODE_VHT40 | IWINFO_HTMODE_VHT80;
	}
	else
	{
		return -1;
	}

	return 0;
}

static int intel_get_channel(const char *ifname, int *buf)
{
	return wext_ops.channel(ifname, buf);
}

static int intel_get_frequency(const char *ifname, int *buf)
{
	return wext_ops.frequency(ifname, buf);
}

static int intel_get_frequency_offset(const char *ifname, int *buf)
{
	//return wext_ops.frequency_offset(ifname, buf);


	/* hack for now - no frequency offset */
	*buf = 0;
	return 0;
}

static int intel_get_txpower_offset(const char *ifname, int *buf)
{
	//return wext_ops.txpower_offset(ifname, buf);


	/* hack for now - no frequency offset */
	*buf = 0;
	return 0;
}

static int intel_get_noise(const char *ifname, int *buf)
{
	return wext_ops.noise(ifname, buf);
}

static int intel_get_quality(const char *ifname, int *buf)
{
	return nl80211_ops.quality(ifname, buf);
}

static int intel_get_quality_max(const char *ifname, int *buf)
{
	return nl80211_ops.quality_max(ifname, buf);
}

static int intel_get_mbssid_support(const char *ifname, int *buf)
{
	return nl80211_ops.mbssid_support(ifname, buf);
}

static int intel_get_ssid(const char *ifname, char *buf)
{
	return wext_ops.ssid(ifname, buf);
}

static int intel_get_bssid(const char *ifname, char *buf)
{
	return wext_ops.bssid(ifname, buf);
}

static int intel_get_hardware_id(const char *ifname, char *buf)
{
	return wext_ops.hardware_id(ifname, buf);
}

static int intel_get_hardware_name(const char *ifname, char *buf)
{
	//return wext_ops.hardware_name(ifname, buf);


	sprintf(buf, "Intel WAV500");
	return 0;
}

static int intel_get_phyname(const char *ifname, char *buf)
{
	return wext_ops.phyname(ifname, buf);
}

static int intel_get_txpwrlist(const char *ifname, char *buf, int *len)
{
	//return nl80211_ops.txpwrlist(ifname, buf, len);


	int i;
	struct iwinfo_txpwrlist_entry entry;
	uint8_t dbm[12] = { 6, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30 };
	uint16_t mw[12] = { 4, 10, 16, 25, 40, 60, 100, 160, 250, 400, 630, 1000 };

	for (i = 0; i < 12; i++)
	{
		entry.dbm = dbm[i];
		entry.mw  = mw[i];
		memcpy(&buf[i*sizeof(entry)], &entry, sizeof(entry));
	}

	*len = 12 * sizeof(entry);
	return 0;
}

static int intel_get_countrylist(const char *ifname, char *buf, int *len)
{
	return nl80211_ops.countrylist(ifname, buf, len);
}

int intel_get_scanlist(const char *ifname, char *buf, int *len)
{
	return wext_ops.scanlist(ifname, buf, len);
}

static void intel_close(void)
{
	return;
}


const struct iwinfo_ops intel_ops = {
	.name             = "intel",
	.probe            = intel_probe,
	.txpower          = intel_get_txpower,
	.bitrate          = intel_get_bitrate,
	.signal           = intel_get_signal,
	.country          = intel_get_country,
	.encryption       = intel_get_encryption,
	.assoclist        = intel_get_assoclist,
	.freqlist         = intel_get_freqlist,
	.mbssid_support   = intel_get_mbssid_support,
	.channel          = intel_get_channel,
	.frequency        = intel_get_frequency,
	.frequency_offset = intel_get_frequency_offset,
	.txpower_offset   = intel_get_txpower_offset,
	.noise            = intel_get_noise,
	.quality          = intel_get_quality,
	.quality_max      = intel_get_quality_max,
	.hwmodelist       = intel_get_hwmodelist,
	.htmodelist       = intel_get_htmodelist,
	.mode             = intel_get_mode,
	.ssid             = intel_get_ssid,
	.bssid            = intel_get_bssid,
	.hardware_id      = intel_get_hardware_id,
	.hardware_name    = intel_get_hardware_name,
	.phyname          = intel_get_phyname,
	.txpwrlist        = intel_get_txpwrlist,
	.scanlist         = intel_get_scanlist,
	.countrylist      = intel_get_countrylist,
	.close            = intel_close,
};

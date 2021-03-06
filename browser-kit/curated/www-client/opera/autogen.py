#!/usr/bin/env python3

from bs4 import BeautifulSoup


async def generate(hub, **pkginfo):
	app = pkginfo["name"]
	src_url = f"https://get.geo.opera.com/pub/opera/desktop/"
	src_data = await hub.pkgtools.fetch.get_page(src_url)
	soup = BeautifulSoup(src_data, "html.parser")
	best_artifact = None
	for link in reversed(soup.find_all("a")):
		href = link.get("href")
		best_artifact = href
		version = best_artifact.rstrip("/")
		test_url = src_url + f"{version}/linux/"
		try:
			# make sure "linux" directory exists and is fetchable -- sometimes a release doesn't have a Linux build:
			await hub.pkgtools.fetch.get_page(test_url)
		except hub.pkgtools.fetch.FetchError as fe:
			continue
		break
	url = src_url + f"{version}/linux/{app}-stable_{version}_amd64.deb"

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
	)
	ebuild.push()


# vim: ts=4 sw=4 noet

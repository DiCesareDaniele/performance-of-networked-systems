
#show "RTTs": it => emph([#it])
#show "RTT": it => emph([#it])
#show "TCP": it => emph([#it])
#show "HTTP": it => emph([#it])

= IV. Performance of TCP-based networks

== 17. Downside of TCP Slow Start
The main downside of TCP Slow Start is that it can significantly underutilize available bandwidth at the beginning of a connection. Because TCP does not know the amount of available bandwidth at startup, it begins with a small congestion window that increases exponentially. This requires multiple RTTs to ramp up, which can lead to noticeable performance degradation, as the network is not used at full capacity during this phase.

This issue is especially apparent when transferring many small files, by the time the congestion window grows large enough to fully utilize the bandwidth, the file transfer is already complete. For example, this was a known problem in early versions of HTTP, where many small files were commonly transferred.

== 18. Slow Start Transfer Times

=== 15KB
The client first establishes a TCP connection using the three-way handshake, which takes one RTT (60 ms).
After the connection is established, the client transmits a single request packet to the server. This packet requires half RTT to reach the server.
The server then processes the request for 50 ms and immediately begins transmitting the first response packet, which arrives at the client after the remaining half RTT.
Up to this point, the transfer time is 170 ms (60ms + 50ms + 60ms).

During Slow Start, the server's congestion window doubles every RTT. After one RTT, the client receives two packets. After another RTT, the window doubles again and the client receives four packets. After one additional RTT, the window doubles to eight packets, although the server only needs to send 5.140 bytes of data, corresponding to four packets. At that point, the transfer completes.

The total time required is therefore:
- 1 RTT for the TCP handshake (60 ms)
- 50 ms of server processing
- 4 RTTs during Slow Start (4 x 60 ms)

This results in a total transfer time of 350 ms.

=== 25KB and 40KB
The procedure is identical to the 15KB case, except that transferring these larger files requires one additional congestion window doubling. This adds one more RTT to the Slow Start phase. Therefore, the total transfer time for both the 25KB and 40KB files is 410 ms.

=== Final Results
The results can be summarized in the following table.
#let file-data = (
  (size: 15, npackets: 11, rtts: 4, t: 350),
  (size: 25, npackets: 18, rtts: 5, t: 410),
  (size: 45, npackets: 29, rtts: 5, t: 410),
)
#table(
  columns: (1fr,) * 4,
  [*File size*], [*Number of packets*], [*Slow Start RTTs*], [*Transmission Time*],
  ..file-data.map(d => ([#{ d.size }KB], [#d.npackets], [#d.rtts], [#{ d.t }ms])).flatten(),
)

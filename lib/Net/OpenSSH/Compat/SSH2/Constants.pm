
use strict;
use warnings;

use Carp;
our %EXPORT_TAGS;

### CONSTANTS BELOW!!!                                        (this is a marker)

#
# The constant definitions are automatically extracted from the real
# Net::SSH2 module and inserted here by the gen_constants_ssh2.pl
# script.
#
# Do not touch by hand!!!
#

sub LIBSSH2_CALLBACK_DEBUG () { 1 }
sub LIBSSH2_CALLBACK_DISCONNECT () { 2 }
sub LIBSSH2_CALLBACK_IGNORE () { 0 }
sub LIBSSH2_CALLBACK_MACERROR () { 3 }
sub LIBSSH2_CALLBACK_X11 () { 4 }
sub LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE () { 1 }
sub LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE () { 2 }
sub LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL () { 0 }
sub LIBSSH2_ERROR_ALLOC () { -6 }
sub LIBSSH2_ERROR_BANNER_NONE () { -2 }
sub LIBSSH2_ERROR_BANNER_SEND () { -3 }
sub LIBSSH2_ERROR_CHANNEL_CLOSED () { -26 }
sub LIBSSH2_ERROR_CHANNEL_EOF_SENT () { -27 }
sub LIBSSH2_ERROR_CHANNEL_FAILURE () { -21 }
sub LIBSSH2_ERROR_CHANNEL_OUTOFORDER () { -20 }
sub LIBSSH2_ERROR_CHANNEL_PACKET_EXCEEDED () { -25 }
sub LIBSSH2_ERROR_CHANNEL_REQUEST_DENIED () { -22 }
sub LIBSSH2_ERROR_CHANNEL_UNKNOWN () { -23 }
sub LIBSSH2_ERROR_CHANNEL_WINDOW_EXCEEDED () { -24 }
sub LIBSSH2_ERROR_DECRYPT () { -12 }
sub LIBSSH2_ERROR_FILE () { -16 }
sub LIBSSH2_ERROR_HOSTKEY_INIT () { -10 }
sub LIBSSH2_ERROR_HOSTKEY_SIGN () { -11 }
sub LIBSSH2_ERROR_INVAL () { -34 }
sub LIBSSH2_ERROR_INVALID_MAC () { -4 }
sub LIBSSH2_ERROR_INVALID_POLL_TYPE () { -35 }
sub LIBSSH2_ERROR_KEX_FAILURE () { -5 }
sub LIBSSH2_ERROR_KEY_EXCHANGE_FAILURE () { -8 }
sub LIBSSH2_ERROR_METHOD_NONE () { -17 }
sub LIBSSH2_ERROR_METHOD_NOT_SUPPORTED () { -33 }
sub LIBSSH2_ERROR_PASSWORD_EXPIRED () { -15 }
sub LIBSSH2_ERROR_PROTO () { -14 }
sub LIBSSH2_ERROR_PUBLICKEY_UNRECOGNIZED () { -18 }
sub LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED () { -19 }
sub LIBSSH2_ERROR_REQUEST_DENIED () { -32 }
sub LIBSSH2_ERROR_SCP_PROTOCOL () { -28 }
sub LIBSSH2_ERROR_SFTP_PROTOCOL () { -31 }
sub LIBSSH2_ERROR_SOCKET_DISCONNECT () { -13 }
sub LIBSSH2_ERROR_SOCKET_NONE () { -1 }
sub LIBSSH2_ERROR_SOCKET_SEND () { -7 }
sub LIBSSH2_ERROR_SOCKET_TIMEOUT () { -30 }
sub LIBSSH2_ERROR_TIMEOUT () { -9 }
sub LIBSSH2_ERROR_ZLIB () { -29 }
sub LIBSSH2_HOSTKEY_HASH_MD5 () { 1 }
sub LIBSSH2_HOSTKEY_HASH_SHA1 () { 2 }
sub LIBSSH2_METHOD_COMP_CS () { 6 }
sub LIBSSH2_METHOD_COMP_SC () { 7 }
sub LIBSSH2_METHOD_CRYPT_CS () { 2 }
sub LIBSSH2_METHOD_CRYPT_SC () { 3 }
sub LIBSSH2_METHOD_HOSTKEY () { 1 }
sub LIBSSH2_METHOD_KEX () { 0 }
sub LIBSSH2_METHOD_LANG_CS () { 8 }
sub LIBSSH2_METHOD_LANG_SC () { 9 }
sub LIBSSH2_METHOD_MAC_CS () { 4 }
sub LIBSSH2_METHOD_MAC_SC () { 5 }
sub LIBSSH2_FX_BAD_MESSAGE () { 5 }
sub LIBSSH2_FX_CONNECTION_LOST () { 7 }
sub LIBSSH2_FX_DIR_NOT_EMPTY () { 18 }
sub LIBSSH2_FX_EOF () { 1 }
sub LIBSSH2_FX_FAILURE () { 4 }
sub LIBSSH2_FX_FILE_ALREADY_EXISTS () { 11 }
sub LIBSSH2_FX_INVALID_FILENAME () { 20 }
sub LIBSSH2_FX_INVALID_HANDLE () { 9 }
sub LIBSSH2_FX_LINK_LOOP () { 21 }
sub LIBSSH2_FX_LOCK_CONFlICT () { 17 }
sub LIBSSH2_FX_NOT_A_DIRECTORY () { 19 }
sub LIBSSH2_FX_NO_CONNECTION () { 6 }
sub LIBSSH2_FX_NO_MEDIA () { 13 }
sub LIBSSH2_FX_NO_SPACE_ON_FILESYSTEM () { 14 }
sub LIBSSH2_FX_NO_SUCH_FILE () { 2 }
sub LIBSSH2_FX_NO_SUCH_PATH () { 10 }
sub LIBSSH2_FX_OK () { 0 }
sub LIBSSH2_FX_OP_UNSUPPORTED () { 8 }
sub LIBSSH2_FX_PERMISSION_DENIED () { 3 }
sub LIBSSH2_FX_QUOTA_EXCEEDED () { 15 }
sub LIBSSH2_FX_UNKNOWN_PRINCIPLE () { 16 }
sub LIBSSH2_FX_WRITE_PROTECT () { 12 }
sub LIBSSH2_FXF_APPEND () { 4 }
sub LIBSSH2_FXF_CREAT () { 8 }
sub LIBSSH2_FXF_EXCL () { 32 }
sub LIBSSH2_FXF_READ () { 1 }
sub LIBSSH2_FXF_TRUNC () { 16 }
sub LIBSSH2_FXF_WRITE () { 2 }
sub LIBSSH2_SFTP_ATTR_ACMODTIME () { 8 }
sub LIBSSH2_SFTP_ATTR_EXTENDED () { 2147483648 }
sub LIBSSH2_SFTP_ATTR_PERMISSIONS () { 4 }
sub LIBSSH2_SFTP_ATTR_SIZE () { 1 }
sub LIBSSH2_SFTP_ATTR_UIDGID () { 2 }
sub LIBSSH2_SFTP_LSTAT () { 1 }
sub LIBSSH2_SFTP_OPENDIR () { 1 }
sub LIBSSH2_SFTP_OPENFILE () { 0 }
sub LIBSSH2_SFTP_PACKET_MAXLEN () { 40000 }
sub LIBSSH2_SFTP_READLINK () { 1 }
sub LIBSSH2_SFTP_REALPATH () { 2 }
sub LIBSSH2_SFTP_RENAME_ATOMIC () { 2 }
sub LIBSSH2_SFTP_RENAME_NATIVE () { 4 }
sub LIBSSH2_SFTP_RENAME_OVERWRITE () { 1 }
sub LIBSSH2_SFTP_SETSTAT () { 2 }
sub LIBSSH2_SFTP_STAT () { 0 }
sub LIBSSH2_SFTP_SYMLINK () { 0 }
sub LIBSSH2_SFTP_TYPE_BLOCK_DEVICE () { 8 }
sub LIBSSH2_SFTP_TYPE_CHAR_DEVICE () { 7 }
sub LIBSSH2_SFTP_TYPE_DIRECTORY () { 2 }
sub LIBSSH2_SFTP_TYPE_FIFO () { 9 }
sub LIBSSH2_SFTP_TYPE_REGULAR () { 1 }
sub LIBSSH2_SFTP_TYPE_SOCKET () { 6 }
sub LIBSSH2_SFTP_TYPE_SPECIAL () { 4 }
sub LIBSSH2_SFTP_TYPE_SYMLINK () { 3 }
sub LIBSSH2_SFTP_TYPE_UNKNOWN () { 5 }
sub LIBSSH2_SFTP_VERSION () { 3 }
sub SSH_DISCONNECT_AUTH_CANCELLED_BY_USER () { croak 'SSH_DISCONNECT_AUTH_CANCELLED_BY_USER is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_BY_APPLICATION () { croak 'SSH_DISCONNECT_BY_APPLICATION is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_COMPRESSION_ERROR () { croak 'SSH_DISCONNECT_COMPRESSION_ERROR is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_CONNECTION_LOST () { croak 'SSH_DISCONNECT_CONNECTION_LOST is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE () { croak 'SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT () { croak 'SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_ILLEGAL_USER_NAME () { croak 'SSH_DISCONNECT_ILLEGAL_USER_NAME is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_KEY_EXCHANGE_FAILED () { croak 'SSH_DISCONNECT_KEY_EXCHANGE_FAILED is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_MAC_ERROR () { croak 'SSH_DISCONNECT_MAC_ERROR is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE () { croak 'SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_PROTOCOL_ERROR () { croak 'SSH_DISCONNECT_PROTOCOL_ERROR is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED () { croak 'SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_RESERVED () { croak 'SSH_DISCONNECT_RESERVED is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_SERVICE_NOT_AVAILABLE () { croak 'SSH_DISCONNECT_SERVICE_NOT_AVAILABLE is not a valid Net::SSH2 macro' }
sub SSH_DISCONNECT_TOO_MANY_CONNECTIONS () { croak 'SSH_DISCONNECT_TOO_MANY_CONNECTIONS is not a valid Net::SSH2 macro' }

%EXPORT_TAGS = (
                 'fx' => [
                           'LIBSSH2_FX_BAD_MESSAGE',
                           'LIBSSH2_FX_CONNECTION_LOST',
                           'LIBSSH2_FX_DIR_NOT_EMPTY',
                           'LIBSSH2_FX_EOF',
                           'LIBSSH2_FX_FAILURE',
                           'LIBSSH2_FX_FILE_ALREADY_EXISTS',
                           'LIBSSH2_FX_INVALID_FILENAME',
                           'LIBSSH2_FX_INVALID_HANDLE',
                           'LIBSSH2_FX_LINK_LOOP',
                           'LIBSSH2_FX_LOCK_CONFlICT',
                           'LIBSSH2_FX_NOT_A_DIRECTORY',
                           'LIBSSH2_FX_NO_CONNECTION',
                           'LIBSSH2_FX_NO_MEDIA',
                           'LIBSSH2_FX_NO_SPACE_ON_FILESYSTEM',
                           'LIBSSH2_FX_NO_SUCH_FILE',
                           'LIBSSH2_FX_NO_SUCH_PATH',
                           'LIBSSH2_FX_OK',
                           'LIBSSH2_FX_OP_UNSUPPORTED',
                           'LIBSSH2_FX_PERMISSION_DENIED',
                           'LIBSSH2_FX_QUOTA_EXCEEDED',
                           'LIBSSH2_FX_UNKNOWN_PRINCIPLE',
                           'LIBSSH2_FX_WRITE_PROTECT'
                         ],
                 'disconnect' => [
                                   'SSH_DISCONNECT_AUTH_CANCELLED_BY_USER',
                                   'SSH_DISCONNECT_BY_APPLICATION',
                                   'SSH_DISCONNECT_COMPRESSION_ERROR',
                                   'SSH_DISCONNECT_CONNECTION_LOST',
                                   'SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE',
                                   'SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT',
                                   'SSH_DISCONNECT_ILLEGAL_USER_NAME',
                                   'SSH_DISCONNECT_KEY_EXCHANGE_FAILED',
                                   'SSH_DISCONNECT_MAC_ERROR',
                                   'SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE',
                                   'SSH_DISCONNECT_PROTOCOL_ERROR',
                                   'SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED',
                                   'SSH_DISCONNECT_RESERVED',
                                   'SSH_DISCONNECT_SERVICE_NOT_AVAILABLE',
                                   'SSH_DISCONNECT_TOO_MANY_CONNECTIONS'
                                 ],
                 'channel' => [
                                'LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE',
                                'LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE',
                                'LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL'
                              ],
                 'all' => [
                            'LIBSSH2_CALLBACK_DEBUG',
                            'LIBSSH2_CALLBACK_DISCONNECT',
                            'LIBSSH2_CALLBACK_IGNORE',
                            'LIBSSH2_CALLBACK_MACERROR',
                            'LIBSSH2_CALLBACK_X11',
                            'LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE',
                            'LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE',
                            'LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL',
                            'LIBSSH2_ERROR_ALLOC',
                            'LIBSSH2_ERROR_BANNER_NONE',
                            'LIBSSH2_ERROR_BANNER_SEND',
                            'LIBSSH2_ERROR_CHANNEL_CLOSED',
                            'LIBSSH2_ERROR_CHANNEL_EOF_SENT',
                            'LIBSSH2_ERROR_CHANNEL_FAILURE',
                            'LIBSSH2_ERROR_CHANNEL_OUTOFORDER',
                            'LIBSSH2_ERROR_CHANNEL_PACKET_EXCEEDED',
                            'LIBSSH2_ERROR_CHANNEL_REQUEST_DENIED',
                            'LIBSSH2_ERROR_CHANNEL_UNKNOWN',
                            'LIBSSH2_ERROR_CHANNEL_WINDOW_EXCEEDED',
                            'LIBSSH2_ERROR_DECRYPT',
                            'LIBSSH2_ERROR_FILE',
                            'LIBSSH2_ERROR_HOSTKEY_INIT',
                            'LIBSSH2_ERROR_HOSTKEY_SIGN',
                            'LIBSSH2_ERROR_INVAL',
                            'LIBSSH2_ERROR_INVALID_MAC',
                            'LIBSSH2_ERROR_INVALID_POLL_TYPE',
                            'LIBSSH2_ERROR_KEX_FAILURE',
                            'LIBSSH2_ERROR_KEY_EXCHANGE_FAILURE',
                            'LIBSSH2_ERROR_METHOD_NONE',
                            'LIBSSH2_ERROR_METHOD_NOT_SUPPORTED',
                            'LIBSSH2_ERROR_PASSWORD_EXPIRED',
                            'LIBSSH2_ERROR_PROTO',
                            'LIBSSH2_ERROR_PUBLICKEY_UNRECOGNIZED',
                            'LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED',
                            'LIBSSH2_ERROR_REQUEST_DENIED',
                            'LIBSSH2_ERROR_SCP_PROTOCOL',
                            'LIBSSH2_ERROR_SFTP_PROTOCOL',
                            'LIBSSH2_ERROR_SOCKET_DISCONNECT',
                            'LIBSSH2_ERROR_SOCKET_NONE',
                            'LIBSSH2_ERROR_SOCKET_SEND',
                            'LIBSSH2_ERROR_SOCKET_TIMEOUT',
                            'LIBSSH2_ERROR_TIMEOUT',
                            'LIBSSH2_ERROR_ZLIB',
                            'LIBSSH2_HOSTKEY_HASH_MD5',
                            'LIBSSH2_HOSTKEY_HASH_SHA1',
                            'LIBSSH2_METHOD_COMP_CS',
                            'LIBSSH2_METHOD_COMP_SC',
                            'LIBSSH2_METHOD_CRYPT_CS',
                            'LIBSSH2_METHOD_CRYPT_SC',
                            'LIBSSH2_METHOD_HOSTKEY',
                            'LIBSSH2_METHOD_KEX',
                            'LIBSSH2_METHOD_LANG_CS',
                            'LIBSSH2_METHOD_LANG_SC',
                            'LIBSSH2_METHOD_MAC_CS',
                            'LIBSSH2_METHOD_MAC_SC',
                            'LIBSSH2_FX_BAD_MESSAGE',
                            'LIBSSH2_FX_CONNECTION_LOST',
                            'LIBSSH2_FX_DIR_NOT_EMPTY',
                            'LIBSSH2_FX_EOF',
                            'LIBSSH2_FX_FAILURE',
                            'LIBSSH2_FX_FILE_ALREADY_EXISTS',
                            'LIBSSH2_FX_INVALID_FILENAME',
                            'LIBSSH2_FX_INVALID_HANDLE',
                            'LIBSSH2_FX_LINK_LOOP',
                            'LIBSSH2_FX_LOCK_CONFlICT',
                            'LIBSSH2_FX_NOT_A_DIRECTORY',
                            'LIBSSH2_FX_NO_CONNECTION',
                            'LIBSSH2_FX_NO_MEDIA',
                            'LIBSSH2_FX_NO_SPACE_ON_FILESYSTEM',
                            'LIBSSH2_FX_NO_SUCH_FILE',
                            'LIBSSH2_FX_NO_SUCH_PATH',
                            'LIBSSH2_FX_OK',
                            'LIBSSH2_FX_OP_UNSUPPORTED',
                            'LIBSSH2_FX_PERMISSION_DENIED',
                            'LIBSSH2_FX_QUOTA_EXCEEDED',
                            'LIBSSH2_FX_UNKNOWN_PRINCIPLE',
                            'LIBSSH2_FX_WRITE_PROTECT',
                            'LIBSSH2_FXF_APPEND',
                            'LIBSSH2_FXF_CREAT',
                            'LIBSSH2_FXF_EXCL',
                            'LIBSSH2_FXF_READ',
                            'LIBSSH2_FXF_TRUNC',
                            'LIBSSH2_FXF_WRITE',
                            'LIBSSH2_SFTP_ATTR_ACMODTIME',
                            'LIBSSH2_SFTP_ATTR_EXTENDED',
                            'LIBSSH2_SFTP_ATTR_PERMISSIONS',
                            'LIBSSH2_SFTP_ATTR_SIZE',
                            'LIBSSH2_SFTP_ATTR_UIDGID',
                            'LIBSSH2_SFTP_LSTAT',
                            'LIBSSH2_SFTP_OPENDIR',
                            'LIBSSH2_SFTP_OPENFILE',
                            'LIBSSH2_SFTP_PACKET_MAXLEN',
                            'LIBSSH2_SFTP_READLINK',
                            'LIBSSH2_SFTP_REALPATH',
                            'LIBSSH2_SFTP_RENAME_ATOMIC',
                            'LIBSSH2_SFTP_RENAME_NATIVE',
                            'LIBSSH2_SFTP_RENAME_OVERWRITE',
                            'LIBSSH2_SFTP_SETSTAT',
                            'LIBSSH2_SFTP_STAT',
                            'LIBSSH2_SFTP_SYMLINK',
                            'LIBSSH2_SFTP_TYPE_BLOCK_DEVICE',
                            'LIBSSH2_SFTP_TYPE_CHAR_DEVICE',
                            'LIBSSH2_SFTP_TYPE_DIRECTORY',
                            'LIBSSH2_SFTP_TYPE_FIFO',
                            'LIBSSH2_SFTP_TYPE_REGULAR',
                            'LIBSSH2_SFTP_TYPE_SOCKET',
                            'LIBSSH2_SFTP_TYPE_SPECIAL',
                            'LIBSSH2_SFTP_TYPE_SYMLINK',
                            'LIBSSH2_SFTP_TYPE_UNKNOWN',
                            'LIBSSH2_SFTP_VERSION',
                            'SSH_DISCONNECT_AUTH_CANCELLED_BY_USER',
                            'SSH_DISCONNECT_BY_APPLICATION',
                            'SSH_DISCONNECT_COMPRESSION_ERROR',
                            'SSH_DISCONNECT_CONNECTION_LOST',
                            'SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE',
                            'SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT',
                            'SSH_DISCONNECT_ILLEGAL_USER_NAME',
                            'SSH_DISCONNECT_KEY_EXCHANGE_FAILED',
                            'SSH_DISCONNECT_MAC_ERROR',
                            'SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE',
                            'SSH_DISCONNECT_PROTOCOL_ERROR',
                            'SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED',
                            'SSH_DISCONNECT_RESERVED',
                            'SSH_DISCONNECT_SERVICE_NOT_AVAILABLE',
                            'SSH_DISCONNECT_TOO_MANY_CONNECTIONS'
                          ],
                 'hash' => [
                             'LIBSSH2_HOSTKEY_HASH_MD5',
                             'LIBSSH2_HOSTKEY_HASH_SHA1'
                           ],
                 'fxf' => [
                            'LIBSSH2_FXF_APPEND',
                            'LIBSSH2_FXF_CREAT',
                            'LIBSSH2_FXF_EXCL',
                            'LIBSSH2_FXF_READ',
                            'LIBSSH2_FXF_TRUNC',
                            'LIBSSH2_FXF_WRITE'
                          ],
                 'callback' => [
                                 'LIBSSH2_CALLBACK_DEBUG',
                                 'LIBSSH2_CALLBACK_DISCONNECT',
                                 'LIBSSH2_CALLBACK_IGNORE',
                                 'LIBSSH2_CALLBACK_MACERROR',
                                 'LIBSSH2_CALLBACK_X11'
                               ],
                 'error' => [
                              'LIBSSH2_ERROR_ALLOC',
                              'LIBSSH2_ERROR_BANNER_NONE',
                              'LIBSSH2_ERROR_BANNER_SEND',
                              'LIBSSH2_ERROR_CHANNEL_CLOSED',
                              'LIBSSH2_ERROR_CHANNEL_EOF_SENT',
                              'LIBSSH2_ERROR_CHANNEL_FAILURE',
                              'LIBSSH2_ERROR_CHANNEL_OUTOFORDER',
                              'LIBSSH2_ERROR_CHANNEL_PACKET_EXCEEDED',
                              'LIBSSH2_ERROR_CHANNEL_REQUEST_DENIED',
                              'LIBSSH2_ERROR_CHANNEL_UNKNOWN',
                              'LIBSSH2_ERROR_CHANNEL_WINDOW_EXCEEDED',
                              'LIBSSH2_ERROR_DECRYPT',
                              'LIBSSH2_ERROR_FILE',
                              'LIBSSH2_ERROR_HOSTKEY_INIT',
                              'LIBSSH2_ERROR_HOSTKEY_SIGN',
                              'LIBSSH2_ERROR_INVAL',
                              'LIBSSH2_ERROR_INVALID_MAC',
                              'LIBSSH2_ERROR_INVALID_POLL_TYPE',
                              'LIBSSH2_ERROR_KEX_FAILURE',
                              'LIBSSH2_ERROR_KEY_EXCHANGE_FAILURE',
                              'LIBSSH2_ERROR_METHOD_NONE',
                              'LIBSSH2_ERROR_METHOD_NOT_SUPPORTED',
                              'LIBSSH2_ERROR_PASSWORD_EXPIRED',
                              'LIBSSH2_ERROR_PROTO',
                              'LIBSSH2_ERROR_PUBLICKEY_UNRECOGNIZED',
                              'LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED',
                              'LIBSSH2_ERROR_REQUEST_DENIED',
                              'LIBSSH2_ERROR_SCP_PROTOCOL',
                              'LIBSSH2_ERROR_SFTP_PROTOCOL',
                              'LIBSSH2_ERROR_SOCKET_DISCONNECT',
                              'LIBSSH2_ERROR_SOCKET_NONE',
                              'LIBSSH2_ERROR_SOCKET_SEND',
                              'LIBSSH2_ERROR_SOCKET_TIMEOUT',
                              'LIBSSH2_ERROR_TIMEOUT',
                              'LIBSSH2_ERROR_ZLIB'
                            ],
                 'method' => [
                               'LIBSSH2_METHOD_COMP_CS',
                               'LIBSSH2_METHOD_COMP_SC',
                               'LIBSSH2_METHOD_CRYPT_CS',
                               'LIBSSH2_METHOD_CRYPT_SC',
                               'LIBSSH2_METHOD_HOSTKEY',
                               'LIBSSH2_METHOD_KEX',
                               'LIBSSH2_METHOD_LANG_CS',
                               'LIBSSH2_METHOD_LANG_SC',
                               'LIBSSH2_METHOD_MAC_CS',
                               'LIBSSH2_METHOD_MAC_SC'
                             ],
                 'sftp' => [
                             'LIBSSH2_SFTP_ATTR_ACMODTIME',
                             'LIBSSH2_SFTP_ATTR_EXTENDED',
                             'LIBSSH2_SFTP_ATTR_PERMISSIONS',
                             'LIBSSH2_SFTP_ATTR_SIZE',
                             'LIBSSH2_SFTP_ATTR_UIDGID',
                             'LIBSSH2_SFTP_LSTAT',
                             'LIBSSH2_SFTP_OPENDIR',
                             'LIBSSH2_SFTP_OPENFILE',
                             'LIBSSH2_SFTP_PACKET_MAXLEN',
                             'LIBSSH2_SFTP_READLINK',
                             'LIBSSH2_SFTP_REALPATH',
                             'LIBSSH2_SFTP_RENAME_ATOMIC',
                             'LIBSSH2_SFTP_RENAME_NATIVE',
                             'LIBSSH2_SFTP_RENAME_OVERWRITE',
                             'LIBSSH2_SFTP_SETSTAT',
                             'LIBSSH2_SFTP_STAT',
                             'LIBSSH2_SFTP_SYMLINK',
                             'LIBSSH2_SFTP_TYPE_BLOCK_DEVICE',
                             'LIBSSH2_SFTP_TYPE_CHAR_DEVICE',
                             'LIBSSH2_SFTP_TYPE_DIRECTORY',
                             'LIBSSH2_SFTP_TYPE_FIFO',
                             'LIBSSH2_SFTP_TYPE_REGULAR',
                             'LIBSSH2_SFTP_TYPE_SOCKET',
                             'LIBSSH2_SFTP_TYPE_SPECIAL',
                             'LIBSSH2_SFTP_TYPE_SYMLINK',
                             'LIBSSH2_SFTP_TYPE_UNKNOWN',
                             'LIBSSH2_SFTP_VERSION'
                           ]
               );


### CONSTANTS ABOVE!!!                                        (this is a marker)

1;

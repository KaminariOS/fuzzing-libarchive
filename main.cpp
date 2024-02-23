#include <stddef.h>
#include <stdint.h>
#include <vector>
#include<iostream>
using namespace std;

#include "archive.h"
#include "archive_entry.h"

int main(int argc, char* argv[]) {
  struct archive *a = archive_read_new();

  archive_read_support_filter_all(a);
  archive_read_support_format_all(a);
  archive_read_support_format_empty(a);
  archive_read_support_format_raw(a);
  archive_read_support_format_gnutar(a);

    if (ARCHIVE_OK != archive_read_set_options(a, "zip:ignorecrc32,tar:read_concatenated_archives,tar:mac-ext")) {
    return 0;
  }
  printf("arg1 %s", argv[1]);
  int r = archive_read_open_filename(a, argv[1], 10240);   
  if (r != ARCHIVE_OK) {
    printf("Bad tar\n");
    exit(1);
  }

  // archive_read_add_passphrase(a, "secret");

  struct archive_entry *entry;
    
  while (archive_read_next_header(a, &entry) == ARCHIVE_OK) {
      printf("%s\n",archive_entry_pathname(entry));
      archive_read_data_skip(a);  // Note 2
    }

  while (1) {
      std::vector<uint8_t> data_buffer(getpagesize(), 0);
      struct archive_entry *entry;
      int ret = archive_read_next_header(a, &entry);
      if (ret == ARCHIVE_EOF || ret == ARCHIVE_FATAL)
          break;
      if (ret == ARCHIVE_RETRY)
          continue;

       (void)archive_entry_pathname(entry);
        (void)archive_entry_pathname_utf8(entry);
        (void)archive_entry_pathname_w(entry);

        (void)archive_entry_atime(entry);
        (void)archive_entry_birthtime(entry);
        (void)archive_entry_ctime(entry);
        (void)archive_entry_dev(entry);
        (void)archive_entry_digest(entry, ARCHIVE_ENTRY_DIGEST_SHA1);
        (void)archive_entry_filetype(entry);
        (void)archive_entry_gid(entry);
        (void)archive_entry_is_data_encrypted(entry);
        (void)archive_entry_is_encrypted(entry);
        (void)archive_entry_is_metadata_encrypted(entry);
        (void)archive_entry_mode(entry);
        (void)archive_entry_mtime(entry);
        (void)archive_entry_size(entry);
        (void)archive_entry_uid(entry);

        ssize_t r;
        while ((r = archive_read_data(a, data_buffer.data(),
            data_buffer.size())) > 0)
      ;
        if (r == ARCHIVE_FATAL)
          break;
  }
        archive_read_has_encrypted_entries(a);
      archive_read_format_capabilities(a);
      archive_file_count(a);
      archive_seek_data(a, 0, SEEK_SET);

    r = archive_read_free(a);  // Note 3
    if (r != ARCHIVE_OK)
      exit(1);
}

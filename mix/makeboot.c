#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
  FILE *output, *input;
  int i, bytes_read, sectors_read, bytes_from_file;
  char buffer[512];

  if (argc < 4) {
    printf("Invalid number of parameters.\n\n");
    printf("USAGE: %s [output] [input 1] [input 2] ... [input n]\n", argv[0]);
    printf("Example: %s a.img bootsect.bin kernel.bin");
    exit(0);
  }

  output = fopen(argv[1], "wb");

  for (i = 2; i < argc; i++) {
    input = fopen(argv[i], "rb");

    if (input == NULL) {
      printf("Missing input file %s. Aborting operation...", argv[i]);
      fclose(output);
      exit(1);
    }

    bytes_read = 512;
    bytes_from_file = 0;
    sectors_read = 0;

    while(bytes_read == 512 && !feof(input)) {
      bytes_read = fread(buffer, 1, 512, input);

      if (bytes_read == 0)
        break;

      if (bytes_read != 512)
        memset(buffer+bytes_read, 0, 512-bytes_read);

      sectors_read++;
      fwrite(buffer, 1, 512, output);
      bytes_from_file += bytes_read;
    }

    printf("%d sectors, %d bytes read from file %s...\n", sectors_read, bytes_from_file, argv[i]);

    fclose(input);
  }

  fclose(output);
  return 0;
}

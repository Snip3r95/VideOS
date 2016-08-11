void os_main() 
{
	//Create a pointer to a char and point it to the first text cell of video memory
	char* video_memory = (char*) 0xb8000;
	//At the address pointed to by video_memory, store the character X
	*video_memory = 'X';
}
/*
void clear_video_mem_text(int start_index = 0, int end_index = 4160)
{
	char* del_mem = 0;
	for(int i = start_index; i < end_index; i++)
	{
		del_mem = video_memory + i;
		*del_mem = ' ';
	}
}
*/
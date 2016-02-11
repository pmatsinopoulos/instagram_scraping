This is a ruby script that can be used to scrape [Instagram](https://instagram.com) and like and comment any post that matches a hash tag.

Usage
=====

Use

```
bundle
```

to install all the necessary gems.

On the command line:

#### If you only want to like and not comment:

```
bundle exec ruby instagram_scraping.rb <your_username> <hash_tag_without_sharp_symbol>
```
such as:

```
bundle exec ruby instagram_scraping.rb panayotism studybreak
```
which will like all the pages with the hashtag `#studybreak`.

#### If you want to like and to add comment:

```
bundle exec ruby instagram_scraping.rb <your_username> <hash_tag_without_sharp_symbol> <relative_path_to_file_with_comments>
```
such as:
```
bundle exec ruby instagram_scraping.rb panayotism studybreak comments.txt
```
where `comments.txt` is a file with comments on the same folder as the program folder. Each line contains one comment. The comments
are used in a round robin manner.






# Milvus DB

Milvus is a powerful open-source vector database that is designed to handle large-scale machine learning and deep learning applications. Some of the best use cases for Milvus include:

- Image and Video Search: Milvus can store and retrieve large amounts of image and video data quickly and accurately. It can be used to power search engines for online marketplaces, social media platforms, and other applications where visual search is important.
- Natural Language Processing: Milvus can be used to store and retrieve large amounts of text data, making it ideal for natural language processing applications. It can be used for sentiment analysis, chatbots, and other text-based applications.
- Anomaly Detection: Milvus can be used to detect anomalies in large datasets. It can be used in fraud detection, network intrusion detection, and other applications where identifying outliers is important.
- Recommendation Systems: Milvus can be used to power recommendation systems, providing users with personalized recommendations based on their past behavior and preferences.
- Facial Recognition: Milvus can be used to store and match facial recognition data quickly and accurately. It can be used for security systems, access control, and other applications where facial recognition is important.


### Milvus cli

#### Installation

```bash
pip install milvus-cli
```

```
:: fedora > milvis_cli
  __  __ _ _                    ____ _     ___
 |  \/  (_) |_   ___   _ ___   / ___| |   |_ _|
 | |\/| | | \ \ / / | | / __| | |   | |    | |
 | |  | | | |\ V /| |_| \__ \ | |___| |___ | |
 |_|  |_|_|_| \_/  \__,_|___/  \____|_____|___|

Milvus cli version: 0.3.2
Pymilvus version: 2.2.1

Learn more: https://github.com/zilliztech/milvus_cli.


milvus_cli > connect <options> # to connect to the database 
# You can always use the help command to help you craft better
```

The best reference how to use their CLI is their (https://github.com/milvus-io/milvus_cli#commands)[Github] page and not the documentation.
As it is more suitable for rapid development.

### Useful commands

```bash
show collections 
delete collection <coll_name>
describe collection -c <coll_name> 
```


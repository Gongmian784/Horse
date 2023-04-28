#include <string>
#include <iostream> // stdout/stdin/stderr
#include <fstream>  // open file
#include <vector>
#include <cmath>
#include <limits>
// C++ for f3 based on beagle with ancestral in dataframe

typedef std::vector<std::string> mylabelsvector;

const std::string DELIMITERS = " \t" ;
const double EPSILON = 1e-5;
const double INF = std::numeric_limits<double>::infinity();

struct siteinfo_struct {
  std::string pos, base1, base2;
};


void getsiteinfo(const std::string &row, size_t &lastOffset, std::string &result){
  int offset = row.find_first_of(DELIMITERS, lastOffset);
  result = row.substr(lastOffset, offset - lastOffset);
  lastOffset = offset+1;
}

void getnextgeno(const std::string &row, size_t &lastOffset, double &result){
  int offset = row.find_first_of(DELIMITERS, lastOffset);
  result = std::stod(row.substr(lastOffset, offset - lastOffset));
  lastOffset = offset+1;
}


void checkfilehandle(std::ifstream &fh, std::string &filename){
  if (! fh.is_open()){
    std::cerr << "Couldnt open file: " << filename << " EXITING " << std::endl;
    exit(EXIT_FAILURE);
  }
}


mylabelsvector parselabels(std::string &labelsfilename){
  mylabelsvector labels;
  std::ifstream labels_fh;
  labels_fh.open(labelsfilename.c_str());
  checkfilehandle(labels_fh, labelsfilename);
  std::string line;
  while (std::getline(labels_fh, line)) {
    labels.push_back(std::move(line));
  }
  return labels;
}


size_t outgroup_index(mylabelsvector labels, std::string &outgroupname){
  size_t index = 0;
  bool outgroupfound = false;
  for (auto name : labels){
    if (name == outgroupname){
      outgroupfound = true;
      break;
    }
    index += 1;
  }
  if (!outgroupfound){
    std::cerr << "Could not find: " << outgroupname << " write the outgroup name as stated in .labels file. EXITING " << std::endl;
    exit(EXIT_FAILURE);
  }
  return index;
}


int main(int argc, char** argv) {
  std::string labelsfilename = argv[argc-2];  // first argument
  std::string outgroupname = argv[argc-1];  // second argument
  mylabelsvector labels = parselabels(labelsfilename);

  size_t outgroup = outgroup_index(labels, outgroupname);
  // on doubles vs double http://stackoverflow.com/questions/2386772/difference-between-double-and-double

  int numberofcomparisons = (labels.size() * (labels.size()-1) / 2);
  std::vector<double> f3 (numberofcomparisons, 0), npos (numberofcomparisons, 0);
  int comparisoncounter, snpcounter = 0;
  std::string row;
  std::cerr << outgroupname << " has 0-based index: " << outgroup << std::endl;
  std::vector<double> freqs;
  freqs.reserve(labels.size());
  double mama, mami, mimi;
  std::string::size_type lastOffset;
  siteinfo_struct siteinfo;
  while(std::getline(std::cin, row)){
    if (snpcounter % 50000 == 0 && snpcounter>0){
      std::cerr << snpcounter << " snps processed. curr_pos: " << siteinfo.pos << "\r";  //  << std::endl;
    }
    lastOffset = 0;
    getsiteinfo(row, lastOffset, siteinfo.pos);
    getsiteinfo(row, lastOffset, siteinfo.base1);
    getsiteinfo(row, lastOffset, siteinfo.base2);
    
    for ( size_t cnt=0 ; cnt < labels.size(); cnt++){
      
      getnextgeno(row, lastOffset, mama);
      getnextgeno(row, lastOffset, mami);
      getnextgeno(row, lastOffset, mimi);
      
      if(std::fabs(mami-mama)<EPSILON && std::fabs(mami-mimi)<EPSILON && std::fabs(mama-mimi)<EPSILON){
        freqs.push_back(INF);
      } else {
        freqs.push_back((0.5 * mami) + mimi);
      }
    }
    snpcounter += 1 ;
    if (std::isfinite(freqs[outgroup])){
      comparisoncounter = 0;
      for (size_t i=0; i < (labels.size()-1); i++){
        if (i == outgroup){
          continue;

        }
        for (size_t j=i+1; j < labels.size(); j++){
          if (j == outgroup ) {
            continue;
          }
          if (std::isfinite(freqs[i]) && std::isfinite(freqs[j])){
            f3[comparisoncounter] += (freqs[outgroup]-freqs[i]) * (freqs[outgroup]-freqs[j]);
            npos[comparisoncounter]++;
          }
          comparisoncounter += 1;
        }
      }
    }
    freqs.clear();
  }

  comparisoncounter = 0;
  for (auto name1=labels.cbegin(); name1 != labels.cend(); name1++){
    if (*name1 == outgroupname) { 
      continue;
    }
    for (auto name2=(name1+1); name2 != labels.cend(); name2++){
      if (*name2 == outgroupname || *name1 == *name2) { 
        continue;
      }
      std::cout << outgroupname << " " << *name1 << " " << *name2 << " " << f3[comparisoncounter] / npos[comparisoncounter] << " " << npos[comparisoncounter] << std::endl;
      comparisoncounter += 1;

    }
  }
}


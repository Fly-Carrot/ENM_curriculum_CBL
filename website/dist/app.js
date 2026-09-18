const chapterLinks=[...document.querySelectorAll('.sticky-toc nav a')];
const chapterSections=[...document.querySelectorAll('.chapter')];
function updateChapter(){let current=chapterSections[0];for(const section of chapterSections){if(section.getBoundingClientRect().top<=170)current=section;else break;}chapterLinks.forEach(link=>{if(current&&link.hash==='#'+current.id)link.setAttribute('aria-current','location');else link.removeAttribute('aria-current');});}
let readingFrame=false;window.addEventListener('scroll',()=>{if(!readingFrame){readingFrame=true;requestAnimationFrame(()=>{updateChapter();readingFrame=false;});}},{passive:true});window.addEventListener('resize',updateChapter);updateChapter();
const figureDialog=document.querySelector('#figure-dialog');
document.querySelectorAll('.result button').forEach(button=>button.addEventListener('click',()=>{const original=button.querySelector('img');figureDialog.querySelector('img').src=original.src;figureDialog.querySelector('img').alt=original.alt;figureDialog.querySelector('p').textContent=button.closest('figure').querySelector('figcaption').textContent;figureDialog.showModal();}));
figureDialog.querySelector('button').addEventListener('click',()=>figureDialog.close());
figureDialog.addEventListener('click',event=>{if(event.target===figureDialog)figureDialog.close();});
const detection=document.querySelector('#detect-rate'),visits=document.querySelector('#visit-count');
function updateDetection(){if(!detection||!visits)return;const p=Number(detection.value)/100,n=Number(visits.value),seen=.6*(1-(1-p)**n);document.querySelector('#detect-label').textContent=`${detection.value}%`;document.querySelector('#visit-label').textContent=`${n} 次`;document.querySelector('#detect-result').textContent=`${(100*seen).toFixed(1)}%`;document.querySelector('#detect-explanation').textContent=`100 个地点中，平均约 ${Math.round(seen*100)} 个至少录到一次；实际上，模型设定有鸟使用的仍是 60 个。`;}
if(detection&&visits){detection.addEventListener('input',updateDetection);visits.addEventListener('input',updateDetection);updateDetection();}
